#!bin/bash
sudo apt update -y
sudo apt install apache -y
sudo systemctl start apache2
sudo systemcrl enable apache2
