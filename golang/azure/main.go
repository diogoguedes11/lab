package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore/to"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/network/armnetwork/v2"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/resources/armresources"
)

const (
    location          = "westus"
    resourceGroupName = "my-rg"
    envSubID          = "AZURE_SUBSCRIPTION_ID"
    virtualNetworkName = "my-vnet"
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

func createResourceGroup(ctx context.Context,subID string , cred *azidentity.DefaultAzureCredential , resourceName string, location string )  {
	resourceGroupClient , err := armresources.NewClientFactory(subID, cred, nil)
	if err != nil {
        log.Fatalf("client factory error: %v", err)
    	}
	rgClient := resourceGroupClient.NewResourceGroupsClient()
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

func createVnetSubnet(ctx context.Context, subID string, cred *azidentity.DefaultAzureCredential) {
    vnetClient, err := armnetwork.NewVirtualNetworksClient(subID, cred, nil)
    if err != nil {
        log.Fatalf("vnet client error: %v", err)
    }

    poller, err := vnetClient.BeginCreateOrUpdate(
        ctx,
        resourceGroupName,
        virtualNetworkName,
        armnetwork.VirtualNetwork{
            Location: to.Ptr(location),
            Properties: &armnetwork.VirtualNetworkPropertiesFormat{
                AddressSpace: &armnetwork.AddressSpace{
                    AddressPrefixes: []*string{to.Ptr("10.0.0.0/16")},
                },
                Subnets: []*armnetwork.Subnet{
                    {
                        Name: to.Ptr("subnet-a"),
                        Properties: &armnetwork.SubnetPropertiesFormat{
                            AddressPrefix: to.Ptr("10.0.1.0/24"),
                        },
                    },
                },
            },
        },
        nil,
    )
    if err != nil {
        log.Fatalf("begin vnet create error: %v", err)
    }

    resp, err := poller.PollUntilDone(ctx, nil)
    if err != nil {
        log.Fatalf("poll vnet create error: %v", err)
    }
    fmt.Printf("VNet created: %s\n", *resp.ID)
}

func main() {

    ctx := context.Background()
    cred, subID := getToken()
  
    createResourceGroup(ctx,subID,cred,resourceGroupName,location)

    createVnetSubnet(ctx,subID,cred)

   
}