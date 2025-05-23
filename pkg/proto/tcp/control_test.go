package tcp

import (
	"testing"

	"github.com/terassyi/network-stack-lab/pkg/packet/ipv4"
	"github.com/terassyi/network-stack-lab/pkg/proto/port"
)

func TestActiveOpen(t *testing.T) {
	peer := port.NewPeer(&ipv4.IPAddress{192, 168, 0, 3}, 8080, 4000)
	cb := NewControlBlock(peer, true)
	packet, err := cb.activeOpen()
	if err != nil {
		t.Fatal(err)
	}
	if cb.state != SYN_SENT {
		t.Fatalf("actual %s", cb.state.String())
	}
	packet.Show()
}

func TestPassiveOpen(t *testing.T) {
	peer := port.NewPeer(&ipv4.IPAddress{192, 168, 0, 3}, 8080, 4000)
	cb := NewControlBlock(peer, true)
	err := cb.passiveOpen()
	if err != nil {
		t.Fatal(err)
	}
	if cb.state != LISTEN {
		t.Errorf("actual %s", cb.state.String())
	}
}
