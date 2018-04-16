import zstd




where = "/home/bence/Documents/"
cctx = zstd.ZstdCompressor()
with open(where+"example.txt",'rb') as ifh, open(where+"example.zstd",'wb') as ofh:
	cctx.copy_stream(ifh,ofh)
