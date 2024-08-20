#!/bin/bash
sudo docker run -it --rm --name kali -v $(pwd)/volume:/opt/app/volume ywy50/kali-tools:v0.0.3 /bin/bash