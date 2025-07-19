#!/usr/bin/env bash
set -e

OUT=linux/libasn1parser.so
SRC_DIR=ios/Classes/generated-files/2024

# Find all .c files except converter-example.c
SOURCES=$(find "$SRC_DIR" -maxdepth 1 -type f -name '*.c' \
           ! -name 'converter-example.c' \
           ! -name 'converter-example-oer.c')

mkdir -p linux

gcc -fPIC -shared \
    $SOURCES \
    -I "$SRC_DIR" \
    -o "$OUT"

echo "Built ASN.1 parser at $OUT"
