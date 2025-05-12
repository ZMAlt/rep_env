
# General settings
GMT_VERSION="6.4.0"
GSHHG_VERSION="2.3.7"
DCW_VERSION="2.1.1"
GSHHG="gshhg-gmt-${GSHHG_VERSION}"
DCW="dcw-gmt-${DCW_VERSION}"
EXT="tar.gz"

# 1. Create temporary directory for building
GMT_INSTALL_DIR=gmt_install
mkdir gmt_install

# 2. Download GMT, GSHHG and DCW from GitHub
git clone --depth=1 --branch ${GMT_VERSION} https://github.com/GenericMappingTools/gmt
curl -SLO https://github.com/GenericMappingTools/gshhg-gmt/releases/download/${GSHHG_VERSION}/${GSHHG}.${EXT}
curl -SLO https://github.com/GenericMappingTools/dcw-gmt/releases/download/${DCW_VERSION}/${DCW}.${EXT}

# 3. Extract tarballs
tar -xvf ${GSHHG}.${EXT}
tar -xvf ${DCW}.${EXT}
mv ${GSHHG} gmt/share/gshhg-gmt
mv ${DCW} gmt/share/dcw-gmt

# 4. Configure GMT
cd gmt/
cat > cmake/ConfigUser.cmake << EOF
set (CMAKE_INSTALL_PREFIX "${GMT_INSTALL_DIR}")
set (CMAKE_C_FLAGS "-Wall -Wdeclaration-after-statement \${CMAKE_C_FLAGS}")
set (CMAKE_C_FLAGS "-Wextra \${CMAKE_C_FLAGS}")
EOF

# 5. Build and install GMT
mkdir build
cd build
cmake .. -G Ninja
cmake --build .
sudo cmake --build . --target install
