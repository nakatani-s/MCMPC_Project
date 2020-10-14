###########################################################

## USER SPECIFIC DIRECTORIES ##

# CUDA directory:
CUDA_ROOT_DIR=/usr/local/cuda


##########################################################

## CC COMPILER OPTIONS ##

# CC compiler options:
CC=g++
CC_FLAGS=
CC_LIBS=

##########################################################

## NVCC COMPILER OPTIONS ##

# NVCC compiler options:
NVCC=nvcc
NVCC_FLAGS=
NVCC_LIBS=

# CUDA library directory:
CUDA_LIB_DIR= -L$(CUDA_ROOT_DIR)/lib64
# CUDA include directory:
CUDA_INC_DIR= -I$(CUDA_ROOT_DIR)/include
# CUDA linking libraries:
CUDA_LINK_LIBS= -lcudart

##########################################################

## Project file structure ##

# mcmpc_src file directory:
MCMPC_SRC_DIR = ../../mcmpc_src

# mcmpc_include file directory:
MCMPC_INC_DIR = ../../include

# Object file directory:
OBJ_DIR = ../../bin

# Main Header directory:
MAIN_DIR = ../../ 

# Source file directory:
SRC_DIR = src

# Include header file diretory:
INC_DIR = include

# MyObject file directory
OBJ_HERE = bin
##########################################################

## Make variables ##

# Target executable name:
EXE = Inverted_Pendulum

# Object files:
OBJS = \
$(OBJ_DIR)/Initializer.o  $(OBJ_DIR)/MCMPC_Controller.o \
$(OBJ_DIR)/cooling_method.o $(OBJ_DIR)/generate_random_input.o \
$(OBJ_DIR)/integrator.o $(OBJ_DIR)/Generic_function.o\
$(OBJ_DIR)/constraint.o \
$(OBJ_HERE)/MyFunctions.o $(OBJ_HERE)/Mymain.o

##########################################################

## Compile ##

# Link CUDA compiled object files to target executable:
$(EXE) : $(OBJS)
	$(NVCC) $(NVCC_FLAGS) $(OBJS) -o $@

# Compile CUDA file in mcmpc_src directory:
$(OBJ_DIR)/%.o : $(MCMPC_SRC_DIR)/%.cu
	$(NVCC) $(NVCC_FLAGS) -dc $< -o $@ $(NVCC_LIBS)

# Compile CUDA file in My directory:
$(OBJ_HERE)/%.o : $(SRC_DIR)/%.cu
	$(NVCC) $(NVCC_FLAGS) -dc $< -o $@ $(NVCC_LIBS)

# Compile main.cu file to object files:
$(OBJ_HERE)/%.o : %.cu 
	$(NVCC) $(NVCC_FLAGS) -c $< -o $@ $(NVCC_LIBS)

# Clean objects in object directory.
clean:
	$(RM) bin/* *.o $(EXE) $(OBJ_DIR)/* *.o