#!/bin/bash
#
# @brief   This script takes a video as input and generates a folder full of images corresponding 
#          to the frames of the video.
#
# @author  Luis Carlos Garcia-Peraza Herrera (luis.herrera.14@ucl.ac.uk).
# @date    29 Jan 2016.

# Constants
FORMAT="png"          # Format of the output images
# IMAGES_PER_SECOND=25  # Number of images that will be stored per second of the video   

##
# @brief Prints the usage help.
usage() {
	echo ''
	echo 'This script converts a video into a folder full of images (PNG format only).'
	echo ''
	echo 'Parameters:'
	echo ''
	echo '    -i   Input video path.'
	echo '    -o   Output folder path.'
	echo '    -f   FPS, sampling frequency of the video. This parameter is optional.'
	echo ''
	echo 'Correct (and only) way to use this script (order matters):'
	echo ''
	echo '    ./convert_images_to_video.sh -i input.mp4 -o output'
	echo ''
	echo '    ./convert_images_to_video.sh -i input.mp4 -o output -f 2'
	echo ''
}

##
# @brief This function parses the command line parameters and make sure 
#        that all the required ones are present.
# @param[in] $@ Command line parameters.
parse_cmdline_parameters() {

	# Sanity checks of the command line parameters
	if [ "$#" -ne 4 ] && [ "$#" -ne 6 ]; then
		usage
		exit 1
	fi
	if [ "$1" != "-i"  ] || [ "$3" != "-o" ]; then
		usage	
		exit 1
	fi	
	if [ "$#" -eq 6 ] && [ "$5" != "-f" ]; then
		usage
		exit 1
	fi
	
	# Store command line parameters
	INPUT_FILE=$2
	OUTPUT_FOLDER=$4

	# Check that the output folder does not exist
	if [ -d "$OUTPUT_FOLDER" ]; then
		echo "The output folder already exists. As a safety measure this script will not do anything."
		exit 1
	fi


}

main() {
	parse_cmdline_parameters "$@"
	
	# If the user does not specify a sampling frequency we will save all the frames
	if [ "$#" -eq 6 ]; then
		IMAGES_PER_SECOND=$6
	else
		IMAGES_PER_SECOND=`printf '%.*f\n' 0 \`ffmpeg -i $INPUT_FILE 2>&1 | grep -i fps | cut -d ',' -f 5 | cut -d ' ' -f 2\``
	fi

	mkdir -p $OUTPUT_FOLDER
	CMD="ffmpeg -i $INPUT_FILE -r $IMAGES_PER_SECOND -f image2 $OUTPUT_FOLDER/%05d.png"
	eval $CMD
}
		   
main "$@"
