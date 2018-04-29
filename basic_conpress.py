import zstd
import sys
import re


class ZstdCompresser:
	def __init__(self):
		self.cctx = zstd.ZstdCompressor()

	@staticmethod
	def to_zstd(base):
		return re.sub("\..*","",base)

	def lets_press(self, infile):
		with open(infile,'rb') as ifh, open(ZstdCompresser.to_zstd(infile) + ".zstd",'wb') as ofh:
			self.cctx.copy_stream(ifh,ofh)

	def lets_multy(self, argv):
		for elem in argv :
			with open(elem,'rb') as ifh, open(ZstdCompresser.to_zstd(elem) + ".zstd" , 'wb') as ofh:
				self.cctx.copy_stream(ifh,ofh)



compr = ZstdCompresser()

if len(sys.argv) > 2 :
	compr.lets_multy(sys.argv[1:])
else :
	compr.lets_press(sys.argv[1])

