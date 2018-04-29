import sys
import random
import os

rnd = random.randint(0, int(sys.argv[2]))
isdir = os.path.isdir(sys.argv[1])

print rnd
print int(sys.argv[2])
print os.path.dirname(sys.argv[1])
print (os.path.splitext(os.path.basename(sys.argv[1]))[0])

if rnd == int(sys.argv[2]):
	if isdir:
		print "a"
	else:
		file = open(sys.argv[1], "a")
		file.write("\nCornPressCornPressCornPressCornPress\n")
		file.write("Sanyiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii")
		file.close()

os.rename(sys.argv[1], (os.path.dirname(sys.argv[1]) + "\\" + (os.path.splitext(os.path.basename(sys.argv[1]))[0]) + ".cp"))