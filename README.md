**CornPress (Demo)**

First install zstd for your python:
- Linux
  - git clone https://github.com/sergey-dryabzhinsky/python-zstd
  - git submodule update --init
  - apt-get install python-dev python3-dev python-setuptools python3-setuptools
  - python setup.py build_ext clean
  - pip install zstandard

- Windows
  - python -m pip install zstd
  - if the upper fails
    - download zstd whl from https://pypi.org/project/zstandard/#files
    - python -m pip install [downloaded .whl]

**Usage of Extender and Deextender**
  - Extender
    - python extender.py infile.zstd [random]
      - random: 1 out of random chance for extend
  - Deextender
    - python deextender.py infile.cp outfile.zstd
    

**Futtatás**

- Linux:
```
CornPress
```

- Windows:
```
CornPress.exe
```

Enjoy!
