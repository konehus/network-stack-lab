package main

import (
	"context"
	"flag"
	"os"

	"github.com/google/subcommands"
	"github.com/terassyi/network-stack-lab/cmd"
)

func main() {
	subcommands.Register(subcommands.HelpCommand(), "")
	subcommands.Register(subcommands.FlagsCommand(), "")
	subcommands.Register(subcommands.CommandsCommand(), "")

	subcommands.Register(&cmd.DumpCommand{}, "")
	subcommands.Register(&cmd.PingCommand{}, "")
	subcommands.Register(&cmd.TcpClientCommand{}, "")
	subcommands.Register(&cmd.TcpServerCommand{}, "")
	subcommands.Register(&cmd.IdsCommand{}, "")

	flag.Parse()
	ctx := context.Background()
	os.Exit(int(subcommands.Execute(ctx)))
}
