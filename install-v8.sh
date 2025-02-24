# Macine instance must be at least e2-meduym

# install depot_tools

git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

# place this line in .bashrc
export PATH=~/depot_tools:$PATH

# Fetch v8
mkdir v8
cd v8
fetch --no-history v8

# install build dependencies
cd v8
./build/install-build-deps.sh

# compile and test
tools/dev/gm.py x64.release
