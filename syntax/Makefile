CC = g++
LIBS = -lfl
CFLAGS = -std=c++11

FLEX_SRC = ffc.flex
FLEX_OUT = ffc.flex.cpp

BISON_SRC = ffc.y
BISON_OUT = ffc.yy.cpp
BFLAGS = --defines -v -b ffc -o $(BISON_OUT)

SRC = $(FLEX_OUT) $(BISON_OUT) output.cpp
HPP = tokens.hpp
OBJS = $(SRC:.cpp=.o)

LEXER = lexer
PARSER = parser

all: $(HPP) Makefile $(PARSER)

$(LEXER): $(OBJS)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

$(PARSER): $(OBJS)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

.cpp.o:
	$(CC) $(CFLAGS) -c $<

$(BISON_OUT): $(BISON_SRC)
	bison $(BFLAGS) $<

$(FLEX_OUT): $(FLEX_SRC) $(BISON_OUT)
	flex -o $@ $<

debug: CFLAGS += -ggdb
debug: clean $(LEXER)

clean:
	rm -f $(FLEX_OUT) $(LEXER) $(OBJS)
