# Target name, include dir, and object dir 
TARGET = Ch10_06
INCDIR1 = .
INCDIR2 = ../../Include
OBJDIR = x64lin

# g++ code generation options
CPPCODE = -m64 -mavx2

# include files
CPPINCFILES1 = $(wildcard $(INCDIR1)/*.h)
CPPINCFILES2 = $(wildcard $(INCDIR2)/*.h)
ASMINCFILES1 = $(wildcard $(INCDIR1)/*.inc)
ASMINCFILES2 = $(wildcard $(INCDIR2)/*.inc)

# .cpp files in current directory   
CPPFILES = $(wildcard *.cpp)
CPPOBJFILES_ = $(CPPFILES:.cpp=.o)
CPPOBJFILES = $(patsubst %, $(OBJDIR)/%, $(CPPOBJFILES_))

# .s files in current directory
ASMFILES = $(wildcard *.s)
ASMOBJFILES_ = $(ASMFILES:.s=.o)
ASMOBJFILES = $(patsubst %, $(OBJDIR)/%, $(ASMOBJFILES_))

# Target object files
OBJFILES = $(CPPOBJFILES) $(ASMOBJFILES)

# g++ and NASM options - required
CPPOPT = $(CPPCODE) -O3 -std=c++20 -Wall -Wextra 
ASMOPT = -f elf64

# g++ and NASM options - optional (comment out to disable)
CPPDEBUG = -g
ASMDEBUG = -g
CPPLISTFILE = -Wa,-aghl=$(OBJDIR)/$(basename $<).lst -save-temps=obj
ASMLISTFILE = -l $(OBJDIR)/$(basename $<).lst -Lm -Ls

# Create directory for object and temp files
MKOBJDIR := $(shell mkdir -p $(OBJDIR))

# Build rules
$(TARGET): $(OBJFILES)
	g++ $(CPPCODE) $(OBJFILES) -o $(TARGET) -lpng

# Note: full recompiles/assembles on any include file changes
$(OBJDIR)/%.o: %.cpp $(CPPINCFILES1) $(CPPINCFILES2)
	g++ -I$(INCDIR1) -I$(INCDIR2) $(CPPOPT) $(CPPDEBUG) $(CPPLISTFILE) -c -o $@ $<

$(OBJDIR)/%.o: %.s $(ASMINCFILES1) $(ASMINCFILES2)
	nasm -I$(INCDIR1) -I$(INCDIR2) $(ASMOPT) $(ASMDEBUG) $(ASMLISTFILE) -o $@ $<

.PHONY:	clean

clean:
	rm -f $(TARGET)
	rm -rf $(OBJDIR)
