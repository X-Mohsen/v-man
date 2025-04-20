#!/bin/bash

# Require root privileges
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script as root (use sudo)"
  exit 1
fi

# Require NIC argument
if [ -z "$1" ]; then
  echo "❌ Usage: sudo $0 <network-interface>"
  echo "   Example: sudo $0 enp5s0"
  exit 1
fi

NIC="$1"
NETPLAN_FILE="/etc/netplan/99-bridge-config.yaml"

# Backup existing Netplan config if it exists
if [ -f "$NETPLAN_FILE" ]; then
  echo "🔁 Backing up existing $NETPLAN_FILE to ${NETPLAN_FILE}.bak"
  cp "$NETPLAN_FILE" "${NETPLAN_FILE}.bak"
fi

# Write bridge configuration
echo "⚙️ Creating Netplan config using NIC: $NIC"
tee "$NETPLAN_FILE" > /dev/null <<EOF
network:
  version: 2
  renderer: NetworkManager
  bridges:
    br0:
      interfaces: [$NIC]
      dhcp4: true
EOF

# Apply Netplan configuration
echo "✅ Applying Netplan configuration..."
netplan apply

echo "🎉 Bridge interface 'br0' has been configured with NIC '$NIC'"
