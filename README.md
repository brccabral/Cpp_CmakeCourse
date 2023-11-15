# CMake, Testing and Tooling for C/C++

Cmake Udemy course https://udemy.com/course/cmake-tests-and-tooling-for-cc-projects  

Add JSON as submodule
```sh
git submodule add --depth 1 https://github.com/nlohmann/json external/json
```

Graphviz - view CMake dependencies in a flow chart  
https://www.graphviz.org/download/  
**Install Doxygen (Graphviz dependency).**  
https://www.doxygen.nl/download.html  
Put `Graphviz\bin` and `doxygen\bin` on `%PATH%`.  
```
cd out\build\x64-debug
cmake ..\..\.. --graphviz=graph.dot
dot.exe -Tpng graph.dot -o graph.png
```

Doxygen - Generates HTML documentation based on code comments  
https://www.doxygen.nl/download.html  
```sh
mkdir docs
cd docs
doxygen -g # this will create Doxygen template file, edit it
```
Edit file docs/Doxygen
- PROJECT_NAME
- PROJECT_NUMBER
- OUTPUT_DIRECTORY
- INPUT
- FILE_PATTERNS
- RECURSIVE

In all source files (`.c`, `.cc`, `.cpp`, `.h`, `.hh`, `.hpp`) add this comment anywhere in the code. This will tell Doxygen to add this file into File List.
```cpp
/// \file
``` 
Run doxygen.
```sh
cd docs
doxygen # now, it will read Doxygen and generate HTML files
```

CPM - Cmake Package Manager  
https://github.com/cpm-cmake/CPM.cmake  
Download the single file `CPM.cmake`. Copy it to `${CMAKE_MODULE_PATH}`.  
It can replace the usage of `FetchContent`.  

Conan - Package Manager
```sh
python -m venv venv
venv\Scripts\activate.bat
pip install conan
conan profile detect # creates a profile, default name is `default`
conan profile path default # outputs `default` profile location
```
Go to https://conan.io/center/ and search for the dependent packages you need.  
For each dependency, review how to setup `conanfile.py`/`conanfile.txt`.  
```sh
conan install . -s build_type=Debug -s compiler.cppstd=17 --output-folder=build --build=missing
cd build
cmake .. -G "Visual Studio 17 2022" -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake
cmake --build . --config Release
```
In VSCode, select `conan-default` as config preset.