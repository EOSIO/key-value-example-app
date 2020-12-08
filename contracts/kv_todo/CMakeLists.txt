project( Contracts )
cmake_minimum_required( VERSION 3.18 )

include( ExternalProject )
# If no `EOSIO_CDT_ROOT` is given use the default path
if( EOSIO_CDT_ROOT STREQUAL "" OR NOT EOSIO_CDT_ROOT )
   find_package( eosio.cdt )
endif()

ExternalProject_Add(
   kv_todo_project
   SOURCE_DIR ${CMAKE_SOURCE_DIR}/src
   BINARY_DIR ${CMAKE_BINARY_DIR}/kv_todo
   CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${EOSIO_CDT_ROOT}/lib/cmake/eosio.cdt/EosioWasmToolchain.cmake
   UPDATE_COMMAND ""
   PATCH_COMMAND ""
   TEST_COMMAND ""
   INSTALL_COMMAND ""
   BUILD_ALWAYS 1
)
