CC = gcc
CFLAGS = -c -fpic -fvisibility=hidden -I.
debug : CFLAGS += -g -O0

LL = gcc
LFLAGS = -shared

OBJDIR = obj
DISTDIR = dist
BINDIR = bin

OBJ = $(OBJDIR)/sahn.o $(OBJDIR)/topo.o

all: init $(OBJ)

dist: all
	@mkdir -p $(DISTDIR)
	@cp sahn/sahn.h $(DISTDIR)
	$(LL) $(LFLAGS) -o $(DISTDIR)/libsahn.so $(OBJ)
	@strip --strip-unneeded $(DISTDIR)/libsahn.so

debug: all
	@mkdir -p $(BINDIR)
	$(LL) $(LFLAGS) -o $(BINDIR)/libsahn_d.so $(OBJ)

init:
	@mkdir -p $(OBJDIR)

clean:
	@rm -rf $(OBJDIR) $(DISTDIR) $(BINDIR)

$(OBJDIR)/sahn.o: sahn/sahn.h sahn/sahn.c sahn/topo.h
	$(CC) $(CFLAGS) -o $(OBJDIR)/sahn.o sahn/sahn.c

$(OBJDIR)/topo.o: sahn/topo.h sahn/topo.c
	$(CC) $(CFLAGS) -o $(OBJDIR)/topo.o sahn/topo.c

#====================
EC = $(CC)
EFLAGS = -Wl,-rpath,$(BINDIR) -L$(BINDIR) -lsahn_d -I. -g -O0

test1: debug examples/test1/test1.c
	$(EC) $(EFLAGS) -o $(BINDIR)/test1 examples/test1/test1.c
