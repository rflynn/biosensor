#!/bin/bash

path=${1:-.}

IFS=$(echo -en "\n\b")
for f in $(find "$path" -name "*.png"); do
    echo "$f"
    #ls -l "$f"
    tmp="${f//.png/-tmp.png}"
    #echo "$tmp"
    convert "$f" -channel RGB -matte -colorspace gray "$tmp"
    mv "$tmp" "$f"
    #ls -l "$f"
done
