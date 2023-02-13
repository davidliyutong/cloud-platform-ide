# Project name/type
project(Homework C)
set(CMAKE_EXPORT_COMPILECOMMANDS ON)

# Build flags
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG_INIT} -Wall -g")

# Source file
file(GLOB SRC
        "src/*.c"
        "src/*.cpp")

# Include headers
include_directories("include")

add_executable(main ${SRC})
