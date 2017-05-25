FROM registry.kechenggezi.com:5001/ruby2.3-imagemagick:self

# install dependencies
RUN apt-get update && apt-get install -y autoconf automake libtool g++ wget && apt-get clean
RUN apt-get update && apt-get install -y libpng12-dev libjpeg62-turbo-dev libtiff5-dev && apt-get clean
RUN apt-get update && apt-get install -y libtesseract-dev libleptonica-dev && apt-get clean
RUN apt-get update && apt-get install -y liblog4cplus-dev && apt-get clean

# build leptonica
RUN wget http://www.leptonica.org/source/leptonica-1.70.tar.gz \
  && tar -zxvf leptonica-1.70.tar.gz \
  && rm leptonica-1.70.tar.gz
WORKDIR leptonica-1.70/
RUN ./autobuild
RUN ./configure
RUN make \
  && make install
RUN ldconfig

# build tesseract
# and
# download the relevant Tesseract English Language Packages
WORKDIR /
RUN wget https://github.com/tesseract-ocr/tesseract/archive/3.02.02.tar.gz \
  && tar -zxvf 3.02.02.tar.gz \
  && rm 3.02.02.tar.gz \
  && wget https://sourceforge.net/projects/tesseract-ocr-alt/files/tesseract-ocr-3.02.eng.tar.gz \
  && tar -xf tesseract-ocr-3.02.eng.tar.gz \
  && rm tesseract-ocr-3.02.eng.tar.gz \
  && cp -r tesseract-ocr/tessdata /usr/local/share/
WORKDIR tesseract-3.02.02/
RUN ./autogen.sh
RUN ./configure
RUN make \
  && make install
RUN ldconfig