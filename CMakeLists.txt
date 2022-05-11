cmake_minimum_required(VERSION 3.10)

project(Remesher
	DESCRIPTION
		"Botsch-Kobbelt Remesher libigl implementation"
)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_BUILD_TYPE "Release")
#set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(EXT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/ext)

find_package(Threads REQUIRED)
find_package(Eigen3)

if(NOT Eigen3_FOUND)
	message(STATUS "Including Eigen from source")

	include(FetchContent)

	FetchContent_Declare(
		eigen
		GIT_REPOSITORY https://gitlab.com/libeigen/eigen.git
		GIT_TAG        3.4.0
  	)

	FetchContent_GetProperties(eigen)
	if(NOT eigen_POPULATED)
		FetchContent_Populate(eigen)
		add_subdirectory(${eigen_SOURCE_DIR} ${eigen_BINARY_DIR})
	endif()
endif()

include_directories(
	# libigl
	${EXT_DIR}/libigl/include
	)

list(APPEND CMAKE_MODULE_PATH ${EXT_DIR}/numpyeigen/cmake)
include(numpyeigen)

add_library(remesh
	# Headers
	src/collapse_edges.h
	src/equalize_valences.h
	src/remesh_botsch.h
	src/split_edges.h
	src/split_edges_until_bound.h
	src/tangential_relaxation.h

	# Source
	src/collapse_edges.cpp
	src/equalize_valences.cpp
	src/remesh_botsch.cpp
	src/split_edges.cpp
	src/split_edges_until_bound.cpp
	src/tangential_relaxation.cpp

	)


target_link_libraries(remesh Threads::Threads Eigen3::Eigen)

add_executable(remeshmesh remeshmesh.cpp)
target_link_libraries(remeshmesh remesh)

npe_add_module(pyremesh
	BINDING_SOURCES
	src/bindings.cpp
)

target_include_directories(pyremesh PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/src")
target_link_libraries(pyremesh PUBLIC remesh)

# Copyt setpath file
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/setpath.sh
               ${CMAKE_CURRENT_BINARY_DIR}/setpath.sh COPYONLY)
