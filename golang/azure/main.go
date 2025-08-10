package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore/to"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/resources/armresources"
)

const (
    location          = "westus"
    resourceGroupName = "my-rg"
    envSubID          = "AZURE_SUBSCRIPTION_ID"
)

func getToken()  (*azidentity.DefaultAzureCredential, string) {
    cred, err := azidentity.NewDefaultAzureCredential(nil)
    if err != nil {
        log.Fatalf("credential error: %v", err)
    }
    // retrieve subscription id from the system
    subID := os.Getenv(envSubID)
    if subID == "" {
        log.Fatalf("env var %s not set", envSubID)
    }
    return cred, subID

}

func createResourceGroup(ctx context.Context,clientFactory *armresources.ClientFactory, resourceName string, location string )  {
	rgClient := clientFactory.NewResourceGroupsClient()
	rgResp, err := rgClient.CreateOrUpdate(
		ctx,
		resourceGroupName,
		armresources.ResourceGroup{Location: to.Ptr(location)},
		nil,
	)
	if err != nil {
		log.Fatalf("create/update RG error: %v", err)
	}

	fmt.Printf("Resource group created: %s (location: %s)\n", *rgResp.ID, *rgResp.Location)

}

func main() {

    ctx := context.Background()
    cred, subID := getToken()
    clientFactory, err := armresources.NewClientFactory(subID, cred, nil)
    if err != nil {
        log.Fatalf("client factory error: %v", err)
    }
    createResourceGroup(ctx,clientFactory,resourceGroupName,location)
}