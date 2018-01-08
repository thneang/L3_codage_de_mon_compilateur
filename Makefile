CC=gcc
CFLAGS=-Wall -I./INCLUDE/ 
LDFLAGS=-Wall -lfl -I./INCLUDE/ 
EXEC=tcompil
SRC=./SRC/
INCLUDE=./INCLUDE/
all: $(EXEC) clean

$(EXEC): $(SRC)$(EXEC).o  $(SRC)lex.yy.o $(SRC)symbole.o
	gcc  -o $@ $^ $(LDFLAGS)
	cp tcompil EXEMPLE/.

$(SRC)$(EXEC).c: $(SRC)$(EXEC).y
	bison -d -o $(SRC)$(EXEC).c $(SRC)$(EXEC).y

$(INCLUDE)$(EXEC).h: $(SRC)$(EXEC).c

$(SRC)lex.yy.c: $(SRC)$(EXEC).lex $(INCLUDE)$(EXEC).h
	flex $(SRC)$(EXEC).lex
	mv lex.yy.c SRC/.

$(SRC)symbole.o : $(SRC)symbole.c $(INCLUDE)symbole.h

%.o: %.c
	gcc -o $@ -c $< $(CFLAGS)

clean:
	rm -f $(SRC)*.o $(SRC)lex.yy.c $(EXEC).[ch]
	rm -f $(SRC)*~ *.o

mrproper: clean
	rm tcompil
	rm ./EXEMPLE/tcompil
