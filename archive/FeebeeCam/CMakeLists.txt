if($ENV{DEBUG})
    message(status " DEBUG")
    add_definitions(-DDEBUG)
else()
    message(status " RELEASE")
    remove_definitions(-DDEBUG)
endif()

add_compile_options(-w -fmax-errors=1)
add_compile_definitions(BOARD_HAS_PSRAM)

# The following lines of boilerplate have to be in your project's
# CMakeLists in this exact order for cmake to work correctly

cmake_minimum_required(VERSION 3.5)

include($ENV{IDF_PATH}/tools/cmake/project.cmake)

project(FeebeeCam)
