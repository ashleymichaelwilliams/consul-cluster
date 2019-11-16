#!/bin/bash
consul agent -config-dir=/consul/consul-config/ -bind='{{GetInterfaceIP "eth0"}}' -node-meta="environment:$CUSTOM_ENV"
