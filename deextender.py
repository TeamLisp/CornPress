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

	def gui_decornpress(self, in_infile):
		self.decornpress(in_infile, (os.path.dirname(in_infile) + "\\" + (os.path.splitext(os.path.basename(in_infile))[0]) + ".zstd"))
if __name__ == '__main__':
	deext = Deextender();
	deext.gui_decornpress(sys.argv[1])
	print "Print, hogy Sanyi oruljon"