package main

import (
	"context"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"time"

	v1 "k8s.io/api/apps/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/kubernetes/scheme"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/util/homedir"
)

func getKubeConfig() string {
	var kubeconfig string
	if home := homedir.HomeDir(); home != "" {
		kubeconfig = filepath.Join(home, ".kube", "config")
	}
	return kubeconfig
}

func getClient(kubeconfig string, timeout time.Duration) (*kubernetes.Clientset, context.Context, context.CancelFunc, error) {
    config, err := clientcmd.BuildConfigFromFlags("", kubeconfig)
    if err != nil {
        return nil, nil, nil, fmt.Errorf("build config: %w", err)
    }
    config.Timeout = timeout
    client, err := kubernetes.NewForConfig(config)
    if err != nil {
        return nil, nil, nil, fmt.Errorf("new clientset: %w", err)
    }
    ctx, cancel := context.WithTimeout(context.Background(), timeout)
    return client, ctx, cancel, nil
}

func listPods(namespace *string,client *kubernetes.Clientset,ctx context.Context) {
	pods, err := client.CoreV1().Pods(*namespace).List(ctx, metav1.ListOptions{Limit: 200})
	if err != nil {
		panic(fmt.Errorf("list pods: %w", err))
	}

	fmt.Printf("Pods in namespace %q: %d\n", *namespace, len(pods.Items))
	for _, pod := range pods.Items {
		fmt.Printf("%s (%s)\n", pod.Name, pod.Status.Phase)
	}
}

func deploy(client *kubernetes.Clientset, ctx context.Context,namespace *string) (map[string]string,error) {
	var  deployment *v1.Deployment
	appFile,err  := os.ReadFile("app.yaml")
	if err != nil {
		fmt.Println("Error while reading the file")
	}
	obj, groupVersionKid, err := scheme.Codecs.UniversalDeserializer().Decode(appFile,nil,nil)
	switch obj.(type) {
		case *v1.Deployment:
			deployment = obj.(*v1.Deployment)
		default:
			return nil, fmt.Errorf("Unrecognized type %s\n",groupVersionKid)

	}
	deploymentResponse, err := client.AppsV1().Deployments(*namespace).Create(ctx,deployment, metav1.CreateOptions{})
	if err != nil {
		return nil,fmt.Errorf("Error while creating deployment %v",err)
	}
	fmt.Println("deploy finished. Deploy with labels %v",deploymentResponse.Spec.Template.Labels)
	return deploymentResponse.Spec.Template.Labels,nil  
}	

func main() {
	
	kubeconfigDefault := getKubeConfig()
	kubeconfig := flag.String("kubeconfig", kubeconfigDefault, "kubeconfig path")
	namespace := flag.String("namespace", "default", "namespace ('' = all)")
	timeout := flag.Duration("timeout", 10*time.Second, "request timeout")
	flag.Parse()
	client, ctx, cancel, err := getClient(*kubeconfig, *timeout)
	if err != nil {
		panic(err)
	}
	defer cancel()
	// listPods(namespace, client,ctx)
	deploy(client,ctx,namespace)
	

}