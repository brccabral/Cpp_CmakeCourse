# CMake, Testing and Tooling for C/C++

![C++](https://img.shields.io/badge/C%2B%2B-17%2F20%2F23-blue)  
![License](https://camo.githubusercontent.com/890acbdcb87868b382af9a4b1fac507b9659d9bf/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c6963656e73652d4d49542d626c75652e737667)  
![Documentation](https://github.com/brccabral/Cpp_CmakeCourse/workflows/Documentation/badge.svg)  
![pre-commit](https://github.com/brccabral/Cpp_CmakeCourse/workflows/pre-commit/badge.svg)  
![Ubuntu Unit Test](https://github.com/brccabral/Cpp_CmakeCourse/workflows/Ubuntu%20CI%20Test/badge.svg)  
![Windows Unit Test](https://github.com/brccabral/Cpp_CmakeCourse/workflows/Windows%20CI%20Test/badge.svg)  
![MacOS Unit Test](https://github.com/brccabral/Cpp_CmakeCourse/workflows/MacOS%20CI%20Test/badge.svg)  

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
Windows  
```bat
cd out\build\x64-debug
cmake ..\..\.. --graphviz=graph.dot
dot.exe -Tpng graph.dot -o graph.png
```
Linux  
```sh
cd out/build/linux-debug
cmake ../../.. --graphviz=graph.dot
dot -Tpng graph.dot -o graph.png
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
cmake .. -G "Visual Studio 17 2022" -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_INSTALL_PREFIX=install_to -DENABLE_SANITIZE_ADDR=OFF -DENABLE_SANITIZE_UNDEF=OFF -DENABLE_LTO=OFF -DUSE_CONAN=ON -DUSE_CPM=OFF
# build
cmake --build . --config Debug --target install
```
In VSCode, select `conan-default` as config preset.  
Conan pre-builds the dependencies without applying Sanitizer or LTO. Need to disable them before building this project.  
For some reason conan presets are not showing in VSCode on Linux. Run these commands:  
```sh
cmake --list-presets
cmake --preset conan-debug
cmake --build --list-presets
cmake --build --preset conan-debug --target install
```

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

9. Clang-Format  

Format C/C++ files based on configuration set at `.clang-format` file. This project is using the instructor's settings.  
Make sure that LLVM installation created `clang-format.exe` in LLVM\bin folder.  
File `tools\run-clang-format.py` is from https://github.com/Sarcasm/run-clang-format.git  
Configure this project and a new target will be available `run_clang_format`. Just run it.  

10. CMake-Format  

Format *.cmake/CMakeLists.txt files based on configuration set at `.cmake-format.yaml`. This project is using the instructor's settings.  
Install using `pip`. This project assumes it is installed in a Virtual Environment `venv`.  
```sh
python -m venv $project/venv
$project/venv/Scripts/activate.bat
pip install cmake-format
```
Configure this project and a new target will be available `run_cmake_format`. Just run it.  

11. GitHub Pages  

Open your reporsitory in GitHub, go to Settings, then Pages.  
In section "Build and deployment" select "GitHub Actions" and create a "Custom Action".  
Put the contents from this project `.github\workflows\documentation.yml` and commit the changes.  
Back to Settings, on left pane select "Actions" (not Actions from GitHub navigation tab, but the left pane in Settings), then choose "General".  
Scroll down and go to "Workflow permissions", allow "Read and write permissions" and save.  
Now, go to Actions from GitHub navigation tab and check the status of the new created action.  
Once it is done, go back to Settings, and in "Build and deployment", in "Source" drop down select "Deploy from a branch".  
The action will have created a branch in you repository called "gh-pages". Select it as your page branch, leave root/ selected and save.  
In your repository main page there will be a section on the right called "Deplyments" and it will contain the link to open the page created.  

12. Code Coverage  

Linux only.  
Checks if your unit tests are testing as much as possible your code (for example, if you have tests for different if/else code flow).  
```sh
apt install gcovr lcov
```
After configuring this project with -DENABLE_COVERAGE=ON, a new target `coverage` will be available. Just run it.  
It will create a new directory `coverage` inside your build directory which will contain an `index.html` file with the results.  

13. CodeCov.io  

In the course the instructor shows how to integrate https://codecov.io with GitHub Actions, but I am not going to do that in this project.  
The instructors adds a new command in "Ubuntu CI Test" that uploads the coverage results to codecov.io, but it requires to allow codecov.io to access my GitHub account which I am not willing to do for this course.  

14. Pre-commit  

When a user tries to commit, a set of actions described `.pre-commit-config.yaml` is executed before the commit takes effect. If any error, the commit is not saved and a log message is presented to the user to make the corrections before another "Staged/Commit".  
```sh
pip install pre-commit
pre-commit install
# install-hooks will look into .pre-commit-config.yaml and load the repos into this project .git/hooks/pre-commit
pre-commit install-hooks 
```
The `clang-tidy` command is something like this:  
```sh
clang-tidy src/*.cpp -- -Ipath/to/include
```
Where everything after `--` is simulating flags passed to the compiler. More complex builds need more flags.  
If you have exported the commands with CMAKE_EXPORT_COMPILE_COMMANDS (only for Makefile Generators and Ninja Generators), we can pass the location of `compile_commands.json` with `clang-tidy -p=directory/`, just the directory containg the file.  
Run this command to check if all is passing.  
```sh
pre-commit run --all-files
```
On Windows, need to use `pre-commit-windows\.pre-commit-config.yaml` because "Visual Studio 17 2022" generator can't export `compile_commands.json`, not even setting CMAKE_EXPORT_COMPILE_COMMANDS.  
This `pre-commit-windows` has different setup for `clang-tidy`.  
Before running it, run the windows preset `x64-debug` so it can prepare the dependencies, then run `pre-commit`.  
```sh
cmake --preset x64-debug
cd pre-commit-windows
pre-commit run --all-files
```
To work with your git repo, open file `.git\hooks\pre-commit` and edit the `--config` option to point to the windows pre-commit .yml file
```sh
ARGS=(hook-impl --config=pre-commit-windows/.pre-commit-config.yaml --hook-type=pre-commit)
```
