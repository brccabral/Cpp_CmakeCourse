# CMake, Testing and Tooling for C/C++

Cmake Udemy course https://udemy.com/course/cmake-tests-and-tooling-for-cc-projects  

Add JSON as submodule
```sh
git submodule add --depth 1 https://github.com/nlohmann/json external/json
```

Graphviz - view CMake dependencies in a flow chart  
https://www.graphviz.org/download/ 

```
cd out\build
cmake ..\.. --graphviz=graph.dot
dot.exe -Tpng graph.dot -o graph.png
```

Doxygen - Generates HTML documentation based on code comments
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