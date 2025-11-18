#!/bin/bash
set -euo pipefail

# Config (override with env vars from Jenkins if you want)
APP="${APP:-HelloWorld4}"            # package name (Package: value)
APP_DIR="${APP_DIR:-helloworldapp}"  # folder under /usr/local/lib/<APP_DIR>
VER="${VER:-1.0.1}"
RID="${RID:-linux-arm64}"              # linux-arm64 for Raspberry Pi or linux-x64 for other
ARCH="${ARCH:-arm64}"                # arm64 for Raspberry Pi or amd64 for other
OUTDIR="${OUTDIR:-out}"
BUILD_DIR="./build"

# Clean build area
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

# Copy repository package template into a clean build dir
# (Assumes your repo/package/ contains DEBIAN/, lib/, usr/ templates)
cp -r ./HelloWorld4/package/* "${BUILD_DIR}/"

# Ensure directories exist under build
mkdir -p "${BUILD_DIR}/usr/local/lib/${APP_DIR}"
mkdir -p "${OUTDIR}"

# Publish the dotnet output INTO the build folder (do NOT publish into repo/package)
echo "Publishing .NET app (RID=${RID})..."
cd HelloWorld4
dotnet publish -c Release -r "${RID}" --self-contained true -o "../${BUILD_DIR}/usr/local/lib/${APP_DIR}"
cd ..

# Ensure binaries are executable (and wrapper in usr/local/bin if present)
if [ -f "${BUILD_DIR}/usr/local/bin/${APP_DIR}" ]; then
  chmod 755 "${BUILD_DIR}/usr/local/bin/${APP_DIR}"
fi
chmod -R 755 "${BUILD_DIR}"

# Build the .deb
DEBNAME="${APP}_${VER}_${ARCH}.deb"
echo "Building deb ${DEBNAME}..."
dpkg-deb --build "${BUILD_DIR}" "${OUTDIR}/${DEBNAME}"

echo "Built ${OUTDIR}/${DEBNAME}"
