#!/bin/bash
#
# @brief Script to extract music from files downloaded with youtoube-dl from YouTube.
#   
# @author Luis C. Garcia-Peraza Herrera (luis.herrera.14@ucl.ac.uk). 
# @date   2 Jan 2017.

# Constants
OUTPUT_FORMAT="mp3"

# Validate command line parameters
if [ "$#" -ne 1 ]; then
	echo "Script to extract the music from YouTube videos in a particular directory."
	echo "Usage: $0 <dir>"
	exit 1
fi

# Read command line parameters
DIR=$1

# Extract music files
for file in $DIR/*; do
	EXT="mkv"
	if [ "${file}" != "${file%.${EXT}}" ]; then
		ffmpeg -i "$file" -vn -acodec $OUTPUT_FORMAT "${file/.$EXT/.$OUTPUT_FORMAT}";
	fi
	EXT="mp4"
	if [ "${file}" != "${file%.${EXT}}" ]; then
		ffmpeg -i "$file" -vn -acodec $OUTPUT_FORMAT "${file/.$EXT/.$OUTPUT_FORMAT}";
	fi
	EXT="webm"
	if [ "${file}" != "${file%.${EXT}}" ]; then
		ffmpeg -i "$file" -vn -acodec $OUTPUT_FORMAT "${file/.$EXT/.$OUTPUT_FORMAT}";
	fi
done

# Delete all video files
read -p "Are you sure you want to delete all video files in $DIR (y/n)? " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo -n "Deleting all MKV files... "
	EXT="mkv"
	rm $DIR/*.$EXT 
	echo "OK"

	echo -n "Deleting all MP4 files... "
	EXT="mp4"
	rm $DIR/*.$EXT 
	echo "OK"

	echo -n "Deleting all WEBM files... "
	EXT="webm"
	rm $DIR/*.$EXT 
	echo "OK"
fi
