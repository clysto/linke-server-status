#!/bin/sh

set -e

read -p "Whether install Nvidia GPU Exporter? [y/N] " install_nvidia_gpu_exporter

install -v -m 755 node_exporter /usr/local/bin/node_exporter
if [ ! -f /usr/local/lib/systemd/system/node_exporter.service ]; then
    install -v -m 644 node_exporter.service /usr/local/lib/systemd/system/node_exporter.service
fi
systemctl daemon-reload && systemctl enable node_exporter && systemctl restart node_exporter

if [ "$install_nvidia_gpu_exporter" = "y" ]; then
    install -v -m 755 nvidia_gpu_exporter /usr/local/bin/nvidia_gpu_exporter
    if [ ! -f /usr/local/lib/systemd/system/nvidia_gpu_exporter.service ]; then
        install -v -m 644 nvidia_gpu_exporter.service /usr/local/lib/systemd/system/nvidia_gpu_exporter.service
    fi
    systemctl daemon-reload && systemctl enable nvidia_gpu_exporter && systemctl restart nvidia_gpu_exporter
fi
