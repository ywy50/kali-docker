#!/bin/bash
git pull
sudo docker build -t kali-tools:latest .
sudo docker image prune -f
sudo docker run -it --rm -v $(pwd)/volume:/opt/app/volume kali-tools:latest /bin/bash