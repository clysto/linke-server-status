#!/bin/sh

set -e

install -v -m 755 node_exporter /usr/local/bin/node_exporter
install -v -m 644 node_exporter.service /usr/local/lib/systemd/system/node_exporter.service
if [ ! -f /var/lib/node_exporter/server_info.prom ]; then
    read -p "Please input server name: " server_name
    read -p "Please input group name: " group_name
    read -p "Please input admin name: " admin_name
    read -p "Please input admin contact: " admin_contact
    install -D -v -m 644 server_info.prom /var/lib/node_exporter/server_info.prom
    echo "server_info{name=\"$server_name\",admin=\"$admin_name\",contact=\"$admin_contact\",group=\"$group_name\"} 1" \
        >/var/lib/node_exporter/server_info.prom
fi
systemctl daemon-reload && systemctl enable node_exporter && systemctl restart node_exporter

read -p "Whether install Nvidia GPU Exporter? [y/N] " install_nvidia_gpu_exporter
if [ "$install_nvidia_gpu_exporter" = "y" ]; then
    install -v -m 755 nvidia_gpu_exporter /usr/local/bin/nvidia_gpu_exporter
    if [ ! -f /usr/local/lib/systemd/system/nvidia_gpu_exporter.service ]; then
        install -v -m 644 nvidia_gpu_exporter.service /usr/local/lib/systemd/system/nvidia_gpu_exporter.service
    fi
    systemctl daemon-reload && systemctl enable nvidia_gpu_exporter && systemctl restart nvidia_gpu_exporter
fi
