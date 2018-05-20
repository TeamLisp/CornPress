import zstd
import sys
import re


class ZstdDecomp:
	def __init__(self):
		self.cctx = zstd.ZstdDecompressor()

	@staticmethod
	def to_zstd(base):
		return re.sub("\..*","",base)

	def lets_decomp(self, infile):
		with open(infile,'rb') as ifh, open(ZstdDecomp.to_zstd(infile),'wb') as ofh:
			self.cctx.copy_stream(ifh,ofh)

	def lets_multy(self, argv):
		for elem in argv :
			with open(elem,'rb') as ifh, open(ZstdDecomp.to_zstd(elem), 'wb') as ofh:
				self.cctx.copy_stream(ifh,ofh)


if __name__ == '__main__':
    compr = ZstdDecomp()

    if len(sys.argv) > 2 :
        compr.lets_multy(sys.argv[1:])
    else :
        compr.lets_decomp(sys.argv[1])

    print "Your file is decornpressed!"
