// From https://medium.com/@chughtapan/running-wireshark-on-docker-ac90ebc4907b

package main

import (
	"fmt"
	"net"
	"os"
	"os/exec"
	"runtime"

	"github.com/vishvananda/netns"
)

func main() {
	// Lock the OS Thread so we don’t accidentally switch namespaces
	runtime.LockOSThread()
	defer runtime.UnlockOSThread()

	// Save the current network namespace
	origns, _ := netns.Get()
	defer origns.Close()

	// Get the network namespace based on container id
	newns, _ := netns.GetFromDocker("e25e1987a44c")
	defer newns.Close()
	netns.Set(newns)

	// Do something with the network namespace
	ifaces, _ := net.Interfaces()
	fmt.Printf("Interfaces: %v\n", ifaces)
	cmd := exec.Command("tshark", "-z", "conv,ip", "-i", "eth0")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	err := cmd.Run()
	if err != nil {
		fmt.Println(err)
	}

	//Return to original namespace
	netns.Set(origns)
}
