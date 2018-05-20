
import unittest
import os
import basic_conpress as compress
import basic_decompress as decompress
import extender as ext
import deextender as deext

class ZstdTestCase(unittest.TestCase):
    comp = compress.ZstdCompresser()
    decomp = decompress.ZstdDecomp()
    windows = os.name == 'nt'
    
    def tearDown(self) :
        files = os.listdir("test")
        for file in files:
            if file.endswith(".zstd") or file.endswith("_test"):
                os.remove(os.path.join("test",file))
    
    def test_small_file(self):
        if self.windows :
            os.system("copy test/small_file test/small_file_test")
        else :
            os.system("cp test/small_file test/small_file_test")
        self.comp.lets_press("test/small_file")
        os.remove("test/small_file")
        self.decomp.lets_decomp("test/small_file.zstd")
        
        with open("test/small_file_test", "rb") as small_file_test:
            test_lines = small_file_test.readlines()
        
        with open("test/small_file", "rb") as small_file:
            zstd_lines = small_file.readlines()
        self.assertEquals(test_lines, zstd_lines)
 
    def test_large_file(self):
        if self.windows :
            os.system("copy test/large_file test/large_file_test")
        else :
            os.system("cp test/large_file test/large_file_test")
        self.comp.lets_press("test/large_file")
        os.remove("test/large_file")
        self.decomp.lets_decomp("test/large_file.zstd")
        
        with open("test/large_file_test", "rb") as large_file_test:
            test_lines = large_file_test.readlines()
        
        with open("test/large_file", "rb") as large_file:
            zstd_lines = large_file.readlines()
        self.assertEquals(test_lines, zstd_lines)
        
    def test_non_ascii_file(self):
        if self.windows :
            os.system("copy test/non_ascii test/non_ascii_test")
        else :
            os.system("cp test/non_ascii test/non_ascii_test")
        self.comp.lets_press("test/non_ascii")
        os.remove("test/non_ascii")
        self.decomp.lets_decomp("test/non_ascii.zstd")
        
        with open("test/non_ascii_test", "rb") as non_ascii_test:
            test_lines = non_ascii_test.readlines()
        
        with open("test/non_ascii", "rb") as non_ascii:
            zstd_lines = non_ascii.readlines()
        self.assertEquals(test_lines, zstd_lines)

    def test_extender(self):
        if self.windows :
            os.system("cp test/cornpress.zstd test/non_cornpress.zstd")
        else :
            os.system("copy test/cornpress.zstd test/non_cornpress.zstd")
        self.ext.cornpress("test/cornpress.zstd", 0)
        os.remove("test/cornpress.zstd")
        self.deextender.decornpress("test/cornpress.cp", "test/cornpress.zstd")
        
        with open("test/non_cornpress.zstd", "rb") as non_cornpress:
            test_lines = non_cornpress.readlines()
        
        with open("test/cornpress.zstd", "rb") as cornpressed:
            zstd_lines = cornpressed.readlines()
        self.assertEquals(test_lines, zstd_lines)

if __name__ == '__main__':
    unittest.main()
