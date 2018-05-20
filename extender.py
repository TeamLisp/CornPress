import sys
import random
import os

class Extender:
	def cornpress(self, infile, number):
		rnd = random.randint(0, int(number))
		isdir = os.path.isdir(infile)
		
		if rnd == int(number):
			if isdir:
				print "a"
			else:
				file = open(infile, "a")
				file.write("\nCornPressCornPressCornPressCornPress\n")
				file.write("Sanyiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii")
				file.close()
		
		os.rename(infile, (os.path.dirname(infile) + "\\" + (os.path.splitext(os.path.basename(infile))[0]) + ".cp"))

if __name__ == '__main__':
	ext = Extender();
	ext.cornpress(sys.argv[1], sys.argv[2])
	print "Print, hogy Sanyi oruljon"