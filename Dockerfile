FROM andreroquem/racket-build

MAINTAINER André Roque Matheus <amatheus@mac.com>

RUN mkdir /app

COPY . /app

RUN cd /app/src; raco test *
