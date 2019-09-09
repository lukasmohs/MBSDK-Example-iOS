#!/bin/bash

pods_root_dir=${PODS_ROOT// /\ }

swiftgen="$pods_root_dir"/SwiftGen/bin/swiftgen

if [ -f "$swiftgen" ];
then
    "$swiftgen"
fi
