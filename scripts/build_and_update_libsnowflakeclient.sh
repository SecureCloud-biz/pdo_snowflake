#!/bin/bash -e
#
# Build and update libsnowflakeclient
#
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[[ -z "$LIBSNOWFLAKECLIENT_HOME" ]] && echo "Set LIBSNOWFLAKECLIENT_HOME to the top directory of libsnowflakeclient directory" && exit 1
target=Debug
source $DIR/_init.sh $@
cd $DIR/..

# Remove the old dependencies and libraries
echo "Removing old build files"
rm -rf "libsnowflakeclient/deps-build/${PLATFORM}"
rm -rf "libsnowflakeclient/include/snowflake"
rm -rf "libsnowflakeclient/lib/${PLATFORM}"

# Make libsnowflakeclient related directories
echo "Setting up build directories"
mkdir -p "libsnowflakeclient/deps-build/${PLATFORM}"
mkdir -p "libsnowflakeclient/include/snowflake"
mkdir -p "libsnowflakeclient/lib/${PLATFORM}"

cd "${LIBSNOWFLAKECLIENT_HOME}"
echo "Building libsnowflakeclient dependencies"
bash scripts/build_dependencies.sh -t Release
echo "Building libsnowflakeclient binary"
bash scripts/build_libsnowflakeclient.sh
cd "${DIR}/.."

# Move da files
echo "Moving updated build files"
cp -r "${LIBSNOWFLAKECLIENT_HOME}/deps-build/${PLATFORM}" "libsnowflakeclient/deps-build/"
cp -r "${LIBSNOWFLAKECLIENT_HOME}/include/snowflake" "libsnowflakeclient/include/"
cp -r "${LIBSNOWFLAKECLIENT_HOME}/cmake-build/libsnowflakeclient.a" "libsnowflakeclient/lib/${PLATFORM}/"
