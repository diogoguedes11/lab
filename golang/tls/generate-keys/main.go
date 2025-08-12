package main

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"os"
)


func generateKeys() ([]byte,[]byte,error) {
	privateKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		return nil, nil, fmt.Errorf("generate key: %w", err)
	}
	derPrivate, err := x509.MarshalPKCS8PrivateKey(privateKey)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error marshalling RSA private key: %s", err)
		return nil, nil, fmt.Errorf("marshal private: %w", err)
	}
	derPublic,err := x509.MarshalPKIXPublicKey(&privateKey.PublicKey)
	if err != nil {
		return nil, nil, fmt.Errorf("marshal public: %w", err)
	}

	keyPublic := pem.EncodeToMemory(&pem.Block{
		Type:  "PUBLIC KEY",
		Bytes: derPublic,
	})
	keyPrivate := pem.EncodeToMemory(&pem.Block{
		Type:  "PRIVATE KEY",
		Bytes: derPrivate,
	})
	return  keyPrivate,keyPublic,nil 
}


func main() {
	var (
		privateKey []byte
		publicKey []byte
		err error
	)
	privateKey,publicKey,err = generateKeys()
	if err != nil {
		fmt.Println("Some error occurred: %w",err)
	}
	fmt.Printf("Private key:\n%s\n", privateKey)
    fmt.Printf("Public key:\n%s\n", publicKey)
}
