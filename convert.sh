#!/bin/bash

#set -x

dir=${1:-vid-tag}

du -hcs "$dir"

IFS=$'\n'
for f in $(find "$dir" -type f -name '*.jpg'); do
    #echo "$f"
    quality=$(identify -verbose "$f" | grep Quality | cut -c 12-)
    if [[ $quality -gt 85 ]]; then
        echo "$f"
        #echo "$quality -gt 85"
        tmp="${f/%.jpg/-q85.jpg}"
        #echo "tmp: $tmp"
        convert -quality 85 "$f" "$tmp" && mv "$tmp" "$f"
    fi
done

du -hcs "$dir"
