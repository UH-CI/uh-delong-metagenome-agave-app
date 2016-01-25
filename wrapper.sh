#!/bin/bash
#set -x

# These variables correspond to the inputs and parameter ids from the apps.json file. 
# The API will pass the actual values into this script prior to execution.
INPUT1=${input1} 
INPUT2=${input2} 
PREFIX=${output_prefix}

# Conditional create an input/output directory in the local scratch folder
if [ ! -d input ]; then mkdir input; fi
if [ ! -d output ]; then mkdir output; fi

# Copy from source directory to the input directory
cp $INPUT1 input/
cp $INPUT2 input/

# Figure out the filename that has been copied into input/
# Here, I use a clever trick for grabbing the last field of any slash-delim path - it's similar in 
# function to basename, but is a simple string operation rather than a system call. It can therefore
# work on URLs as well as iRODS paths and local filesystem paths.
#
# See http://tldp.org/LDP/LGNET/18/bash.html for more cool stuff like this.
#
FILENAME1=${INPUT1##*/} 
FILENAME2=${INPUT2##*/} 


# Check for existence of input file...
if [ -e input/$FILENAME1 ]; then
	if [ -e input/$FILENAME2 ]; then
		source ~/.bash_profile
		
		mafft --auto input/$FILENAME > output/mafft-app_output.fasta
		make -j 6 -f /home/jmeppley/apps/opt/moleculardb/makefiles/Makefile.uhhpc.mira SAMPLE_NAME=S32C001aa R1_FASTQ=CSHLIID00-20a-S32C001-0015_S9_R1_001.fastqaa R2_FASTQ=CSHLIID00-20a-S32C001-0015_S9_R2_001.fastqaa RESUME_MIRA=-r all

	    make -j 6 -f /lus/scratch/software/opt/moleculardb/makefiles/Makefile.uhhpc.mira SAMPLE_NAME=S32C001aa R1_FASTQ=CSHLIID00-20a-S32C001-0015_S9_R1_001.fastqaa R2_FASTQ=CSHLIID00-20a-S32C001-0015_S9_R2_001.fastqaa RESUME_MIRA=-r all

	fi

fi

# no need to stage out data, your output will be archived for you.

