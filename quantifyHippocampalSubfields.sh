#!/bin/bash

# This script is not mine, and I don't know by who is wroten it.

# Define a function that exits if something goes wrong.
function doIt {

  command="$1"

  eval "$command"

  if [ $? != 0 ]; then
    echo "failed to do $command"
    exit -1
  fi
}


if [ $# -le 1 ]; then
  echo "Usage: $0 suffix outputFile [subjectsDirectory]"
  exit -1
fi


suffix=$1
outputfile=$2;
resultsDirectory=$SUBJECTS_DIR
if [ $# -ge 3 ]; then
  resultsDirectory=$3
fi

# Show what we have
echo "Gathering results from subjects in: "
echo "   $resultsDirectory "
echo "Using the suffix name: "
echo "   $suffix"
echo "And writing them to: "
echo "   $outputfile "


# Go to the output directory
doIt "cd $resultsDirectory"


# List all subdirectories (subjects)
subjectNames=(`ls -d */`) # list only directories
numberOfSubjects=${#subjectNames[*]}

# Go inside each subject's subdirectory and collect volumes


namesWritten="no"
for i in `eval echo {1..$numberOfSubjects}`; do

  # Get subject name
  let subjectIndex=$i-1
  subjectName=${subjectNames[ $subjectIndex ]}
  subjectName=`echo "${subjectName//\/}"` # strips the /


  # Files with volumes
  leftVolFile="$resultsDirectory/$subjectName/mri/lh.hippoSfVolumes-${suffix}.v10.txt"
  rightVolFile="$resultsDirectory/$subjectName/mri/rh.hippoSfVolumes-${suffix}.v10.txt"

  echo $leftVolFile
  if [ -f $leftVolFile ]; then
  	echo "File is existed."
  fi

  # If they exist, collect data
  if [ -f $leftVolFile ] && [ -f $rightVolFile ]; then

     echo "Collecting data for subject: $subjectName"
    
     # if it's the first subject, gather names of structures
     if [ $namesWritten == "no" ]; then
        namesWritten="yes"
     
        nameString="Subject "; 
        while read line; do
          arr=(`echo ${line}`);
          nameString="$nameString  left_${arr[0]}" 
        done < $leftVolFile

        while read line; do
          arr=(`echo ${line}`);
          nameString="$nameString  right_${arr[0]}"
        done < $leftVolFile
 
        echo $nameString > $outputfile

     fi
    
     volumes="$subjectName"; 
     while read line; do
       arr=(`echo ${line}`);
       volumes="$volumes  ${arr[1]}" 
     done < $leftVolFile
     while read line; do
       arr=(`echo ${line}`);
       volumes="$volumes  ${arr[1]}" 
     done < $rightVolFile

     echo $volumes >> $outputfile

  else
    # echo "Skipping directory $subjectName "
    dummy=" "
  fi

done # End loop over all subjects


