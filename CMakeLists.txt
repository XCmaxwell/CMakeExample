cmake_minimum_required(VERSION 3.6)

message("=== Build system info:")
message("    Build System: ${CMAKE_HOST_SYSTEM}")
message("    Build system name: ${CMAKE_HOST_SYSTEM_NAME}")
message("    Build system version: ${CMAKE_HOST_SYSTEM_VERSION}")
message("    Build system arch: ${CMAKE_HOST_SYSTEM_PROCESSOR}")


set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_STYLE "Auto")
set(CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM "Y72J85XF23")



add_subdirectory(src)

project(testFramework VERSION 1.0)