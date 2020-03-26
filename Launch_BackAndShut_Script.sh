#!/bin/bash
# Launch the BackAndShut script along with logging
bash -x /home/snyssen/Scripts/BackAndShut.sh >>/home/snyssen/Scripts/Logs/BackAndShut_`date +"%Y-%m-%d"`.log 2>&1
