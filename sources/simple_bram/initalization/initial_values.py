#!/usr/bin/env python3
#
# Utility to estimate panel refresh rate given some
# BCM parameters.
#
# Copyright (C) 2019-2020 Sylvain Munaut
# SPDX-License-Identifier: MIT
#

import argparse

def main():
	# Parse options
	parser = argparse.ArgumentParser()
	parser.add_argument('--input_file',    required=True,           help='Path to the input file')
	parser.add_argument('--encoding_base', required=True, type=int, help='The type of encoding for the input file. 2 for binary, 8 for octal, 10 for decimal, 16 for hex')
	parser.add_argument('--fill_memory',                  type=int, help='What to fill the remaining memory locations with', default=0)
	parser.add_argument('--output_file',   required=True,           help='The output file to write to')
	parser.add_argument('--output_width',  required=True, type=int, help='The width of the output file (how many characters per line)')
	parser.add_argument('--output_depth',  required=True, type=int, help='The depth of the output file (how many lines)')

	args = parser.parse_args()

	if not ((args.encoding_base & (args.encoding_base - 1) == 0) and args.encoding_base != 0):
		print("Invalid encoding type. Please choose a valid number. Use the -h option for help")
		exit()


	with open(args.input_file, 'r') as input, open(args.output_file, 'w') as output:
		line = input.readline()
		line_num = 0

		# Read from input file and write to the output file
		while line != '':
			if line[0] == '-':
				line = input.readline()
			else:
				try:
					bin_out = bin(int(line, base=args.encoding_base))[2:].zfill(args.output_width)

					if len(bin_out) > args.output_width:
						print(f"\nERROR: Output line width greater than specified output width. Check that line {line_num} of input file gives the correct output width\n")
						break

				except ValueError:
						print(f"\nERROR: Could not parse input file. Check that specified encoding type matches input file type. (Error at line {line_num} of input file )\n")
						break

				output.write(bin_out + "\n")
				line_num += 1
				line = input.readline()
 
		# Check if desired number of lines were output, fill with value if it is given
		if line_num != args.output_depth:
			if args.fill_memory is not None:
				for _ in range(line_num, args.output_depth):
					bin_out = bin(args.fill_memory)[2:].zfill(args.output_width)
					output.write(bin_out + "\n")
					line_num += 1
			else:
				print(f"\nINFO: Only {line_num} lines were written to the output file when {args.output_depth} lines were expected to be written. \n      Maybe use --fill_memory to fill the rest of the lines")
		
		print(f"\n{line_num} lines successfully written to output file {args.output_file}\n")

if __name__ == '__main__':
	main()
