CC=g++
CFLAGS=-g -Wall
LIBS=/usr/local/cgicc/lib/libcgicc.a

TARGET= cgi_get.cgi cgi_post.cgi

all: ${TARGET}

%.cgi: %.cpp
	${CC} ${CFLAGS} -o $@ $< ${LIBS}


cgi_get.cgi:   cgi_get.cpp 
cgi_post.cgi:  cgi_post.cpp


clean:
	-rm -f a.out ${TARGET}

