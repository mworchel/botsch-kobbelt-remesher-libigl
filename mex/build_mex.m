    mex('remeshmesh_mex.cpp','../src/remesh_botsch.cpp','../src/collapse_edges.cpp',...
    '../src/equalize_valences.cpp','../src/split_edges.cpp',...
    '../src/split_edges_until_bound.cpp','../src/tangential_relaxation.cpp',...
    '-I/usr/local/Cellar/eigen',...
    '-I/usr/local/Cellar/eigen/3.3.9/include/eigen3',...
    '-I../ext/libigl/include')
