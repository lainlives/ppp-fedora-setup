#!/bin/bash
set -e

source .env

echo "========================"
echo "00-create-empty-image.sh"
echo "========================"

# Approximately 6GB image.
echo "Create image called $OUT_NAME? Make sure this doesn't exist, or it will be replaced."
if [ ! -z "$PS1" ]; then
    read -p "Continue? [y/N] " -n 1 -r
else
    REPLY=y
fi
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
    if [[ -e "$OUT_NAME" ]]
    then
        echo "Removing pre-existing $OUT_NAME."
        unlink $OUT_NAME
    fi

    # Create this as a sparse file
    echo "Creating sparse blank 6GB file called $OUT_NAME."
    dd if=/dev/zero of=$OUT_NAME bs=1 count=0 seek=6G && sync

fi
