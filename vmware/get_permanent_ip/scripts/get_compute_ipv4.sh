#!/bin/bash

NODE_IP=$1
IFS=',' read -a NODEIPARR <<< "${NODE_IP}"
FILTEREDARR=()
for A_NODE_IP in "${NODEIPARR[@]}"; do
        if [[ $A_NODE_IP == "192.168.1"* ]]; then
                FILTEREDARR+=( $A_NODE_IP )
        fi
done
FILTEREDARRLIST=$(IFS=, ; echo "${FILTEREDARR[*]}")
echo {\"compute\":\"${FILTEREDARRLIST}\"}