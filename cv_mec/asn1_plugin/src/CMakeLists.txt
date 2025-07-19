cmake_minimum_required(VERSION 3.10)
project(asn1_plugin_linux)

add_library(asn1_plugin SHARED dummy.cpp)

install(TARGETS asn1_plugin
        LIBRARY DESTINATION "${FLUTTER_LIBRARY_DIR}")