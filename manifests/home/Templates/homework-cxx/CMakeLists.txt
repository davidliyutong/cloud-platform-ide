# Project name/type
project(Homework CXX)
set(CMAKE_EXPORT_COMPILECOMMANDS ON)

# Build flags
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG_INIT} -Wall -g")

# Source file
file(GLOB SRC
        "src/*.c"
        "src/*.cpp")

# Include headers
include_directories("include")

add_executable(main ${SRC})
