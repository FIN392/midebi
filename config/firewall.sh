#!/usr/bin/env bash
set -Eeuo pipefail

# Configurar firewall
sudo cat << 'EOF' | sudo tee /etc/nftables.conf > /dev/null
#!/usr/sbin/nft -f
flush ruleset
table inet filter {
    chain input {
        type filter hook input priority filter; policy drop;
        # Tráfico interno
        iifname "lo" accept
        # Respuestas DHCP
        udp sport 67 udp dport 68 accept
        udp sport 547 udp dport 546 accept
        # Conexiones establecidas o relacionadas
        ct state established,related accept
        # ICMP IPv4 e IPv6
        ip protocol icmp accept
        meta l4proto ipv6-icmp accept
    }
}
EOF
sudo chmod 644 /etc/nftables.conf
sudo systemctl enable --now nftables
