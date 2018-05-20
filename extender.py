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
		if self.windows :
            os.rename(infile, (os.path.dirname(infile) + "\\" + (os.path.splitext(os.path.basename(infile))[0]) + ".cp"))
        else :
			os.rename(infile, (os.path.dirname(infile) + "/" + (os.path.splitext(os.path.basename(infile))[0]) + ".cp"))

	def gui_cornpress(self, infile):
		self.cornpress(infile, 10)
		
if __name__ == '__main__':
	ext = Extender();
	ext.gui_cornpress(sys.argv[1])
	print "Print, hogy Sanyi oruljon"