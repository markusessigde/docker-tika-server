FROM ubuntu:latest

ENV TIKA_VERSION 1.24
ENV TIKA_SERVER_URL https://www.apache.org/dist/tika/tika-server-$TIKA_VERSION.jar


# set noninteractive installation
ENV DEBIAN_FRONTEND noninteractive


RUN	apt-get update \
	&& apt-get install gnupg \
			openjdk-11-jre-headless \
			curl \
			gdal-bin \
 			build-essential \
			tzdata \
			python3-pip \
			python3-tk \
			libpng-dev \
			tesseract-ocr \
		    tesseract-ocr-eng \
			tesseract-ocr-ita \
			tesseract-ocr-fra \
			tesseract-ocr-spa \
			tesseract-ocr-deu -y \
	&& ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
	&& curl -sSL https://www.imagemagick.org/download/ImageMagick.tar.gz -o ImageMagick.tar.gz \
    && tar xf ImageMagick.tar.gz \
    && cd ImageMagick-7* \
    && ./configure \
    && make \
    && make install \
    && ldconfig /usr/local/lib \
    && cd ../ \
    && rm -rf ImageMagick.tar.gz ImageMagick-7* \
	&& pip3 install numpy scikit-image matplotlib \
	&& curl -sSL https://people.apache.org/keys/group/tika.asc -o /tmp/tika.asc \
	&& gpg --import /tmp/tika.asc \
	&& mkdir -p /app/org/apache/tika/parser/ocr
	&& curl -sSL "$TIKA_SERVER_URL.asc" -o /tmp/tika-server-${TIKA_VERSION}.jar.asc \
	&& NEAREST_TIKA_SERVER_URL=$(curl -sSL http://www.apache.org/dyn/closer.cgi/${TIKA_SERVER_URL#https://www.apache.org/dist/}\?asjson\=1 \
		| awk '/"path_info": / { pi=$2; }; /"preferred":/ { pref=$2; }; END { print pref " " pi; };' \
		| sed -r -e 's/^"//; s/",$//; s/" "//') \
	&& echo "Nearest mirror: $NEAREST_TIKA_SERVER_URL" \
	&& curl -sSL "$NEAREST_TIKA_SERVER_URL" -o /app/tika-server-${TIKA_VERSION}.jar \
	&& apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD TesseractOCRConfig.properties /app/org/apache/tika/parser/ocr/TesseractOCRConfig.properties
ADD convert.sh /app/convert

RUN chmod +x /app/convert

EXPOSE 9998
ENTRYPOINT java -cp /app:/app/tika-server-${TIKA_VERSION}.jar org.apache.tika.server.TikaServerCli -h 0.0.0.0
