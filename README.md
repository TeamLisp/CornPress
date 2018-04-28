**CornPress (Demo)**

First install zstd for your python:
- Linux
  - git clone https://github.com/sergey-dryabzhinsky/python-zstd
  - git submodule update --init
  - apt-get install python-dev python3-dev python-setuptools python3-setuptools
  - python setup.py build_ext clean

- Windows
  - python -m pip install zstd
  - if the upper fails
    - download zstd whl from https://pypi.org/project/zstandard/#files
    - python -m pip install [downloaded .whl]
    
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
