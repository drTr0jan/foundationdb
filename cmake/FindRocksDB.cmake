# FindRocksDB

find_path(ROCKSDB_INCLUDE_DIR
  NAMES rocksdb/db.h
  PATH_SUFFIXES include)

if(ROCKSDB_INCLUDE_DIR AND EXISTS "${ROCKSDB_INCLUDE_DIR}/rocksdb/version.h")
  foreach(ver "MAJOR" "MINOR" "PATCH")
    file(STRINGS "${ROCKSDB_INCLUDE_DIR}/rocksdb/version.h" ROCKSDB_VER_${ver}_LINE
      REGEX "^#define[ \t]+ROCKSDB_${ver}[ \t]+[0-9]+$")
    string(REGEX REPLACE "^#define[ \t]+ROCKSDB_${ver}[ \t]+([0-9]+)$"
      "\\1" ROCKSDB_VERSION_${ver} "${ROCKSDB_VER_${ver}_LINE}")
    unset(${ROCKSDB_VER_${ver}_LINE})
  endforeach()
  set(ROCKSDB_VERSION_STRING
    "${ROCKSDB_VERSION_MAJOR}.${ROCKSDB_VERSION_MINOR}.${ROCKSDB_VERSION_PATCH}")

  message(STATUS "Found RocksDB version: ${ROCKSDB_VERSION_STRING}")
endif()

if(ROCKSDB_INCLUDE_DIR)
  find_library(ROCKSDB_STATIC_LIBRARY
    NAMES librocksdb.a)
  if(ROCKSDB_STATIC_LIBRARY)
    add_library(rocksdb STATIC IMPORTED)
    message(STATUS "Found RocksDB library: ${ROCKSDB_STATIC_LIBRARY}")
    message(STATUS "Found RocksDB includes: ${ROCKSDB_INCLUDE_DIR}")

    find_library(bz2_STATIC_LIBRARIES libbz2.a)
    find_library(lz4_STATIC_LIBRARIES liblz4.a)
    find_library(Snappy_STATIC_LIBRARIES libsnappy.a)
    find_library(zstd_STATIC_LIBRARIES libzstd.a)
    find_library(zlib_STATIC_LIBRARIES libz.a)

    set(ROCKSDB_LIBRARIES
      ${ROCKSDB_STATIC_LIBRARY}
      ${bz2_STATIC_LIBRARIES} ${lz4_STATIC_LIBRARIES} ${Snappy_STATIC_LIBRARIES}
      ${zstd_STATIC_LIBRARIES} ${zlib_STATIC_LIBRARIES})

    mark_as_advanced(
      ROCKSDB_LIBRARIES
      ROCKSDB_INCLUDE_DIR
    )
  endif()
endif()

find_package_handle_standard_args(RocksDB
  REQUIRED_VARS ROCKSDB_INCLUDE_DIR
  VERSION_VAR ROCKSDB_VERSION_STRING)
