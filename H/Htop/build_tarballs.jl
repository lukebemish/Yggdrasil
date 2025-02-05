# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "Htop"
version = v"3.1.2"

# Collection of sources required to complete build
sources = [
    ArchiveSource("https://github.com/htop-dev/htop/releases/download/$(version)/htop-$(version).tar.xz",
                  "884bce5b58cb113127860b9e368609019e92416a81550fdf0752052f3a64b388"),
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/htop-*/
./configure --prefix=${prefix} --build=${MACHTYPE} --host=${target}
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms(; exclude=Sys.iswindows)

# The products that we will ensure are always built
products = [
    ExecutableProduct("htop", :htop)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    Dependency("Ncurses_jll"),
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat = "1.6")

