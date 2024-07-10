#!/bin/bash
docker run -it --rm -v $(pwd)/volume:/opt/app/volume kalitools:latest /bin/bash