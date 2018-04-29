import os
import sys

infile = open(sys.argv[1], "rb")
outfile = open (sys.argv[2], "wb")

for line in infile:
	if line == "CornPressCornPressCornPressCornPress\r\n" :
		break
	elif line == "CornPressCornPressCornPressCornPress\n" :
		break
	else:
		outfile.write(line)

infile.close()
outfile.close()