#!/bin/bash
rm -r build-ios
mkdir build-ios
cd build-ios
cmake .. -G Xcode \
    -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake \
    -DPLATFORM=OS64 \
    -DARCHS=arm64 \
    -DDEPLOYMENT_TARGET=12.0 \
    -DAPPLE=1 \
    -DENABLE_STRICT_TRY_COMPILE=TRUE\
    -DENABLE_VISIBILITY=TRUE 
# cmake --build . --config Debug
cmake --build . --config Release