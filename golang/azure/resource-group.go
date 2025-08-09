package main

import (
	"fmt"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
)

func main() {
	cred, err := azidentity.NewDefaultAzureCredential(nil)

	if err != nil {
		fmt.Printf("failed to obtain credential: %v",err)
	}
}