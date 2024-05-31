#!/usr/bin/env bash
set -euo pipefail

# Script to rename project from 'gotcp' to 'network-stack-lab' throughout the repository

echo "Renaming module path in go.mod..."
sed -i 's|^module github.com/terassyi/gotcp|module github.com/terassyi/network-stack-lab|' go.mod

echo "Updating import paths..."
grep -Rl "github.com/terassyi/gotcp" . --exclude-dir=.git | xargs sed -i 's|github.com/terassyi/gotcp|github.com/terassyi/network-stack-lab|g' || true

echo "Replacing standalone 'gotcp' references..."
grep -Rw gotcp . --exclude-dir=.git | xargs sed -i 's|\<gotcp\>|network-stack-lab|g' || true

echo "Updating Docker Compose settings..."
sed -i 's|/usr/home/gotcp|/usr/home/network-stack-lab|g' docker-compose.yml

echo "Updating Vagrantfile paths..."
sed -i 's|/home/vagrant/gotcp|/home/vagrant/network-stack-lab|g' vm/node1/Vagrantfile
sed -i 's|/home/vagrant/gotcp|/home/vagrant/network-stack-lab|g' vm/node2/Vagrantfile

echo "Updating README.md title..."
sed -i 's|^# Gotcp|# network-stack-lab|' README.md
sed -i 's|\<Gotcp\>|network-stack-lab|g' README.md

echo "Renaming completed. Please review changes, then commit and push."