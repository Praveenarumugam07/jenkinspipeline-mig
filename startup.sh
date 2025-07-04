#!/bin/bash
# Startup script for GCP instance template
sudo apt update
sudo apt install -y python3-pip
pip3 install -r /home/Praveenarumugam07/requirements.txt
python3 /home/Praveenarumugam07/app.py
