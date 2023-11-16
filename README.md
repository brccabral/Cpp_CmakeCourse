# CMake, Testing and Tooling for C/C++

Cmake Udemy course https://udemy.com/course/cmake-tests-and-tooling-for-cc-projects  

1. Add JSON as submodule  

```sh
git submodule add --depth 1 https://github.com/nlohmann/json external/json
```

2. Graphviz - view CMake dependencies in a flow chart  

https://www.graphviz.org/download/  
**Install Doxygen (Graphviz dependency).**  
https://www.doxygen.nl/download.html  
Put `Graphviz\bin` and `doxygen\bin` on `%PATH%`.  
```
cd out\build\x64-debug
cmake ..\..\.. --graphviz=graph.dot
dot.exe -Tpng graph.dot -o graph.png
```

3. Doxygen - Generates HTML documentation based on code comments  

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

4. CPM - Cmake Package Manager  

https://github.com/cpm-cmake/CPM.cmake  
Download the single file `CPM.cmake`. Copy it to `${CMAKE_MODULE_PATH}`.  
It can replace the usage of `FetchContent`.  
Set `-DUSE_CMP=ON`  

5. Conan - Package Manager  

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
# configure (change CMAKE_INSTALL_PREFIX or other values)
cmake .. -G "Visual Studio 17 2022" -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_INSTALL_PREFIX=install_to -DENABLE_SANITIZE_ADDR=OFF -DENABLE_SANITIZE_UNDEF=OFF -DENABLE_LTO=OFF -DUSE_CONAN=ON
# build
cmake --build . --config Debug --target install
```
In VSCode, select `conan-default` as config preset.  
Conan pre-builds the dependencies without applying Sanitizer or LTO. Need to disable them before building this project.  

6. VCPKG - Package Manager  

Clone or download VCPKG https://github.com/microsoft/vcpkg  
Run the `bootstrap.bat` and add the folder to your path to have access to `vcpkg.exe`.  
Create file `vcpkg.json` in your project. The `dependencies` are only minimal versions, to pin-point a version, add it to `overrides`.  
Also, `builtin-baseline` is the commit hash of vcpkg that will be executed.  
When configuring CMake, pass in `-DVCPKG_DIR=C:\path\to\vcpkg`.  
Run command below. VCPKG will download and compile the requested dependencies from `vcpkg.json`.  
```sh
vcpkg install
```
They will be in `${VCPKG_DIR}\packages`, but just include `${VCPKG_DIR}/scripts/buildsystems/vcpkg.cmake` into your CMake and it will find the packages location.  
VCPKG pre-builds the dependencies without applying Sanitizer or LTO. Need to disable them before building this project.  

7. Install Clang/LLVM
When installing "Visual Studio", go to "Individual components" tab, search for "llvm" and install "C++ Clang Compiler for Windows" and "MSBuild support for LLVM"
Add to PATH
- C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build
- C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\Llvm\bin
- C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin

8. Clang-Tidy
After installing LLVM above, go to "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\Llvm\bin" and copy file "run-clang-tidy" into this project "tools\run-clang-tidy.py".  
On Windows we need to use "Visual Studio" for this. Open the solution file `projectname.sln` in VS, right click the solution, select "Analyze and Code Cleanup", and then "Run Code Analysis on \<target\>".  
Remember to enable ENABLE_CLANG_TIDY, and disable ENABLE_SANITIZE_ADDR, ENABLE_SANITIZE_UNDEF and ENABLE_LTO.  
On Linux, a new target is created as `<target>_clangtidy`, just run it.  
