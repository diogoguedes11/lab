package main

import (
	"context"
	"flag"
	"fmt"
	"path/filepath"
	"time"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/util/homedir"
)


func getClient(kubeconfig string, timeout time.Duration) (*kubernetes.Clientset, context.Context, context.CancelFunc, error) {
    config, err := clientcmd.BuildConfigFromFlags("", kubeconfig)
    if err != nil {
        return nil, nil, nil, fmt.Errorf("build config: %w", err)
    }
    config.Timeout = timeout
    clientset, err := kubernetes.NewForConfig(config)
    if err != nil {
        return nil, nil, nil, fmt.Errorf("new clientset: %w", err)
    }
    ctx, cancel := context.WithTimeout(context.Background(), timeout)
    return clientset, ctx, cancel, nil
}

func main() {
    fmt.Println("Hello Kubernetes")

    // Flags (defined once)
    var kubeconfigDefault string
    if home := homedir.HomeDir(); home != "" {
        kubeconfigDefault = filepath.Join(home, ".kube", "config")
    }
    kubeconfig := flag.String("kubeconfig", kubeconfigDefault, "kubeconfig path")
    namespace := flag.String("namespace", "default", "namespace ('' = all)")
    timeout := flag.Duration("timeout", 10*time.Second, "request timeout")
    flag.Parse()

    clientset, ctx, cancel, err := getClient(*kubeconfig, *timeout)
    if err != nil {
        panic(err)
    }
    defer cancel()

    pods, err := clientset.CoreV1().Pods(*namespace).List(ctx, metav1.ListOptions{Limit: 200})
    if err != nil {
        panic(fmt.Errorf("list pods: %w", err))
    }

    fmt.Printf("Pods in namespace %q: %d\n", *namespace, len(pods.Items))
    for _, pod := range pods.Items {
        fmt.Printf("%s (%s)\n", pod.Name, pod.Status.Phase)
    }
}