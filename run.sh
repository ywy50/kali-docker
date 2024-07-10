#!/bin/bash
sudo docker run -it --rm -v $(pwd)/volume:/opt/app/volume kali-tools:latest /bin/bash