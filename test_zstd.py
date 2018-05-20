
import unittest
import os
import basic_conpress as compress
import basic_decompress as decompress


class ZstdTestCase(unittest.TestCase):
    comp = compress.ZstdCompresser()
    decomp = decompress.ZstdDecomp()
    
    def tearDown(self) :
        files = os.listdir("test")
        for file in files:
            if file.endswith(".zstd") or file.endswith("_test"):
                os.remove(os.path.join("test",file))
    
    def test_small_file(self):
        os.system("cp test/small_file test/small_file_test")
        self.comp.lets_press("test/small_file")
        os.system("rm test/small_file")
        self.decomp.lets_decomp("test/small_file.zstd")
        
        with open("test/small_file_test", "rb") as small_file_test:
            test_lines = small_file_test.readlines()
        
        with open("test/small_file", "rb") as small_file:
            zstd_lines = small_file.readlines()
        self.assertEquals(test_lines, zstd_lines)
 
    def test_large_file(self):
        os.system("cp test/large_file test/large_file_test")
        self.comp.lets_press("test/large_file")
        os.system("rm test/large_file")
        self.decomp.lets_decomp("test/large_file.zstd")
        
        with open("test/large_file_test", "rb") as large_file_test:
            test_lines = large_file_test.readlines()
        
        with open("test/large_file", "rb") as large_file:
            zstd_lines = large_file.readlines()
        self.assertEquals(test_lines, zstd_lines)
        
    def test_non_ascii_file(self):
        os.system("cp test/non_ascii test/non_ascii_test")
        self.comp.lets_press("test/non_ascii")
        os.system("rm test/non_ascii")
        self.decomp.lets_decomp("test/non_ascii.zstd")
        
        with open("test/non_ascii_test", "rb") as non_ascii_test:
            test_lines = non_ascii_test.readlines()
        
        with open("test/non_ascii", "rb") as non_ascii:
            zstd_lines = non_ascii.readlines()
        self.assertEquals(test_lines, zstd_lines)

if __name__ == '__main__':
    unittest.main()