#! /usr/bin/env bash
set -ex

export MINION_ID=M5KVK

cd /mnt/data/mlat
/tmp/sdr/build/src/rtl_sdr -f 200e6 -h 100e6 -n 1e3 /mnt/data/mlat/M5KVK_202103101733.iq
sleep infinity