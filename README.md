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