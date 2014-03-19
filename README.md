# Virgo Example Agent

## Purpose

This project is a template to create a minimally viable Virgo Agent. The entry
point must be ```init.lua``` which exports a run function.

## Compilation

```
git submodule update --init --recursive
./configure
make -C out -j
out/Debug/virgo
```
