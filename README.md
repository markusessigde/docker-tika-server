# Based on [LogicalSpark/docker-tikaserver](https://github.com/LogicalSpark/docker-tikaserver)
This repo is used to build the docker image on raspberrypi.

# tika-server
This repo contains the Dockerfile to create a docker image that contains the latest Ubuntu running the Apache Tika 1.24.1 Server on Port 9998 using Java 11.

Out-of-the-box the container also includes dependencies for the GDAL and Tesseract OCR parsers.  To balance showing functionality versus the size of the image, this file currently installs the language packs for the following languages:
* English
* French
* German
* Italian
* Spanish.

To install more languages simply update the apt-get command to include the package containing the language you required, or include your own custom packs using an ADD command.

This container includes imagemagick and python3 so that 
the TesseractOCR parser preprocessing images for better results.

There is a second version with opencv instead of imagemagick for image preprocessing.

## Usage

First you need to pull down the build from Dockerhub, which can be done by invoking:

    docker pull markusessigde/tika-server

Then to run the container, execute the following command:

    docker run -d -p 9998:9998 markusessigde/tika-server

## Building

To build the image from scratch, simply invoke:

    docker build -t 'tika-server' github.com/markusessigde/tika-server
   
You can then use the following command (using the name you allocated in the build command as part of -t option):

    docker run -d -p 9998:9998 tika-server
    
## More

For more info on Apache Tika Server, go to the [Apache Tika Server documentation](http://wiki.apache.org/tika/TikaJAXRS)
