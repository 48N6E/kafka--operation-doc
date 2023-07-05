#!/bin/bash
mkdir -p /root/resjson
for i in `ls /root/topic`;do bash dec-new.sh /root/topic/$i > /root/resjson/$i-res.json  ;done
