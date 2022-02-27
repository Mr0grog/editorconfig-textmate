#!/usr/bin/env bash
set -euo pipefail

VERSION='10.39'
PCRE2_DIR=$(cd $(dirname $0) && pwd)
SOURCE_PATH="${PCRE2_DIR}/pcre2-${VERSION}"
BUILD_PATH="${PCRE2_DIR}/pcre2-build"

# Download a copy of the pcre2 source
if [ ! -d "${SOURCE_PATH}" ]; then
  mkdir -p "${PCRE2_DIR}"
  cd "${PCRE2_DIR}"
  echo "Downloading pcre2 ${VERSION}..."
  curl --location "https://github.com/PhilipHazel/pcre2/releases/download/pcre2-${VERSION}/pcre2-${VERSION}.tar.bz2" > "${SOURCE_PATH}.tar.bz2"
  tar -xzf "${SOURCE_PATH}.tar.bz2"
fi

echo "Building pcre2..."
cd "${SOURCE_PATH}"
mkdir -p "${BUILD_PATH}"
# Loosely based on Homebrew's settings
CFLAGS='-arch x86_64 -arch arm64 -mmacosx-version-min=11.0' ./configure \
  --disable-dependency-tracking \
  --enable-pcre2grep-libz \
  --enable-pcre2grep-libbz2 \
  --enable-jit \
  --prefix "${BUILD_PATH}"
make
make install

# Verify architectures
ARCHITECTURES="$(lipo -info "${BUILD_PATH}/lib/libpcre2-8.a")"
if [[ "${ARCHITECTURES}" != *'x86_64'* ]] || [[ "${ARCHITECTURES}" != *'arm64'* ]]; then
  echo ""
  echo "----------------------------------------------"
  echo "It should have built a universal binary for x86_64 and arm64, but got:"
  echo "  ${ARCHITECTURES}"
  exit 1
fi

# Copy relevant files
cp "${SOURCE_PATH}/LICENCE" "${PCRE2_DIR}/LICENCE-pcre"
cp "${BUILD_PATH}/lib/libpcre2-8.a" "${PCRE2_DIR}/"
cp -R "${BUILD_PATH}/include" "${PCRE2_DIR}/include"
