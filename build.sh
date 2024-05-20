#!/bin/bash

mkdir -p release
mkdir -p cache/node_exporter
mkdir -p cache/nvidia_gpu_exporter

NODE_EXPORTER_URL=https://github.com/prometheus/node_exporter/releases/download/v1.8.0/node_exporter-1.8.0.linux-amd64.tar.gz
NVIDIA_GPU_EXPORTER_URL=https://github.com/utkuozdemir/nvidia_gpu_exporter/releases/download/v1.2.0/nvidia_gpu_exporter_1.2.0_linux_x86_64.tar.gz

if [ ! -f cache/node_exporter.tar.gz ]; then
    wget -O cache/node_exporter.tar.gz $NODE_EXPORTER_URL
fi

if [ ! -f cache/nvidia_gpu_exporter.tar.gz ]; then
    wget -O cache/nvidia_gpu_exporter.tar.gz $NVIDIA_GPU_EXPORTER_URL
fi

tar -xvf cache/node_exporter.tar.gz -C cache/node_exporter
tar -xvf cache/nvidia_gpu_exporter.tar.gz -C cache/nvidia_gpu_exporter

node_exporter_bin=$(find cache/node_exporter/ -name "node_exporter" -type f)
nvidia_gpu_exporter_bin=$(find cache/nvidia_gpu_exporter/ -name "nvidia_gpu_exporter" -type f)

cp $node_exporter_bin release/
cp $nvidia_gpu_exporter_bin release/
cp node_exporter.service release/
cp nvidia_gpu_exporter.service release/
cp setup.sh release/
cp server_info.prom release/

makeself release exporters_installer.run "Node Exporter and Nvidia GPU Exporter installer" ./setup.sh
