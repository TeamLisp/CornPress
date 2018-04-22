import zstd
import sys

infile = sys.argv[1]
outfile = sys.argv[2]

cctx = zstd.ZstdDecompressor()
with open(infile,'rb') as ifh, open(outfile,'wb') as ofh:
	cctx.copy_stream(ifh,ofh)
