import os
import sys

class Deextender:
	def decornpress(self, in_infile, in_outfile):
		infile = open (in_infile, "rb")
		outfile = open (in_outfile, "wb")
		for line in infile:
			if line == "CornPressCornPressCornPressCornPress\r\n" :
				break
			elif line == "CornPressCornPressCornPressCornPress\n" :
				break
			else:
				outfile.write(line)
		
		infile.close()
		outfile.close()

if __name__ == '__main__':
	deext = Deextender();
	deext.decornpress(sys.argv[1], sys.argv[2])