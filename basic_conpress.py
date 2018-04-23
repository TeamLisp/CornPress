import zstd
import sys
import re

class ZstdCompresser:
	def __init__(self):
		self.cctx = zstd.ZstdCompressor()

	@staticmethod
	def to_zstd(base):
		return re.sub("\..*","",base)

	def lets_press(self, infile, outfile):
		with open(infile,'rb') as ifh, open(outfile,'wb') as ofh:
			self.cctx.copy_stream(ifh,ofh)

	def lets_multy(self, *argv):
		for elem in argv :
			with open(elem,'rb') as ifh, open(ZstdCompresser.to_zstd(elem), 'wb') as ofh:
				self.cctx.copy_stream(ifh,ofh)



compr = ZstdCompresser()
compr.lets_press("infile.txt","infile.zstd")
compr.lets_multy("out.me","compress.me","good.me")
