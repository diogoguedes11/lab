package main

import (
	"bytes"
	"fmt"
	"log"
	"os"

	"golang.org/x/crypto/ssh"
)


func main() {
	// publicKey, err := os.ReadFile("mykey.pub") // authorized keys
	privateKey , err := os.ReadFile("mykey.pem") 
	// sshPublicKey, _, _, _, err := ssh.ParseAuthorizedKey(publicKey)
	serverHostKey , err := os.ReadFile("id_rsa.pub")
	serverPublicKey, _, _, _, err := ssh.ParseAuthorizedKey(serverHostKey)

	sshPrivateKey, err := ssh.ParsePrivateKey(privateKey)
	if err != nil {
		panic("Failed to parse private key")
	}
	config := &ssh.ClientConfig{	
		User: "admin",
		Auth: []ssh.AuthMethod{
			ssh.PublicKeys(sshPrivateKey),
		},
		HostKeyCallback: ssh.FixedHostKey(serverPublicKey),

	}
	client, err := ssh.Dial("tcp", "localhost:2222", config)
	if err != nil {
		log.Fatal("Failed to dial: ", err)
	}
	defer client.Close()
	// Each ClientConn can support multiple interactive sessions,
	// represented by a Session.
	session, err := client.NewSession()
	if err != nil {
		log.Fatal("Failed to create session: ", err)
	}
	defer session.Close()

	// Once a Session is created, you can execute a single command on
	// the remote side using the Run method.
	var b bytes.Buffer
	session.Stdout = &b
	if err := session.Run("/usr/bin/whoami"); err != nil {
		log.Fatal("Failed to run: " + err.Error())
	}
	fmt.Println(b.String())
}

