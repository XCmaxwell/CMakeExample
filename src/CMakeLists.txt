
macro (set_xcode_property TARGET XCODE_PROPERTY XCODE_VALUE)
set_property (TARGET ${TARGET} PROPERTY XCODE_ATTRIBUTE_${XCODE_PROPERTY}
    ${XCODE_VALUE})
endmacro (set_xcode_property)

# 在这里所指示的目录将会成为最终framework/Headers底下的目录
set(dir1 dir1/test.cc dir1/test.h)
set(dir1_ios dir1/ios/test_ios.cc dir1/ios/test_ios.h)

add_library(testFramework
    ${dir1}
    ${dir1_ios}
    )  

# 这里链接了第三方库：opencv.framework和几个系统库
set_target_properties(testFramework PROPERTIES
    #-F后面接着的是opencv2.framework所在目录
    LINK_FLAGS "-W1,-F${CMAKE_CURRENT_SOURCE_DIR}/3party/opencv/ios"
    )
target_link_libraries(testFramework 
        "-framework opencv2"
        "-framework Foundation" 
        "-framework CoreVideo"
        "-framework coreml"
        )

# 列出要编译的所有源文件和头文件
set(SRC_FILES
    ${dir1}
    ${dir1_ios}
    )

# 从SRC_FILES列表中找出所有头文件，并放入INCLUDE_FILES变量中
set(INCLUDE_FILES "")

foreach(file ${SRC_FILES})
    # 通过识别".h"子字符串的方式得出一个文件是否是头文件，所以.h和.hpp文件都会被找到
    string(FIND ${file} ".h" pos REVERSE)  
    if(NOT ${pos} MATCHES "-1")
        message(STATUS "header file: ${file}")
        list(APPEND INCLUDE_FILES ${file})
    endif()
endforeach(file)
set(INCLUDE_FILES ${INCLUDE_FILES} CACHE INTERNAL "List of include files" FORCE)

set_xcode_property(testFramework GCC_GENERATE_DEBUGGING_SYMBOLS YES "ALL")
set_target_properties(testFramework PROPERTIES
    FRAMEWORK TRUE
    FRAMEWORK_VERSION A
    MACOSX_FRAMEWORK_IDENTIFIER cn.yrhxxxx.comp
    VERSION 1.0.0
    SOVERSION 1.0.0
    #PUBLIC_HEADER ${INCLUDE_FILES} # 使用另一种方法生成Headers/，所以PUBLIC_HEADER就不用了
    )

# 将INCLUDE_FILES变量中的所有文件按其路径名放入testFramework.framework/Headers中
foreach(hfile ${INCLUDE_FILES})
    # 截取出hfile变量中的路径
    string(FIND ${hfile} "/" pos REVERSE)  # 得出最后一个"/"的位置pos
    string(SUBSTRING ${hfile} 0 ${pos} dir)
    message(STATUS "subDir: ${dir}")
    # MACOSX_PACKAGE_LOCATION关键字可以将文件复制到特定的路径中，在IOS framework中，
    # 就是<name>.framework/
    set_property(SOURCE ${hfile} PROPERTY 
                MACOSX_PACKAGE_LOCATION Headers/${dir})
endforeach(hfile)

include_directories(
    .
    ${CMAKE_CURRENT_SOURCE_DIR}/3party/opencv/ios/opencv2.framework
    )