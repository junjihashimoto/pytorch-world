{ stdenv, fetchzip
}:

stdenv.mkDerivation rec {
  name = "libmklml";
  version = "0.17.2"
  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchzip {
        url = "https://github.com/intel/mkl-dnn/releases/download/v0.17.2/mklml_lnx_2019.0.1.20181227.tgz";
        sha256 = "0g9fd97pcbzsfslj8j517jwl2rflqqsph3dny553pw62gqiy92gr";
      }
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      fetchzip {
        url = "https://github.com/intel/mkl-dnn/releases/download/v0.17.2/mklml_mac_2019.0.1.20181227.tgz";
        sha256 = "01vbvp1khd118rskcaszwl0vw7z30bnwqcs88ah4fj1i9q5k7z7k";
      }
    else throw "missing url for platform ${stdenv.hostPlatform.system}";

  installPhase = ''
    ls $src
    mkdir $out
    cp -r {$src,$out}/include/
    cp -r {$src,$out}/lib/
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
#    for f in $(ls $out/lib/*.dylib); do
#        install_name_tool -id @rpath/$(basename $f) $(basename $f) || true
#    done
#    install_name_tool -change @rpath/libshm.dylib $out/lib/libshm.dylib $out/lib/libtorch_python.dylib
  '';

  # postInstall = ''
  #   # Make boost header paths relative so that they are not runtime dependencies
  #   cd "$dev" && find include \( -name '*.hpp' -or -name '*.h' -or -name '*.ipp' \) \
  #     -exec sed '1i#line 1 "{}"' -i '{}' \;
  # '';

  meta = with stdenv.lib; {
    description = "libmklml";
    homepage = https://software.intel.com/en-us/mkl
    license = { free = false; fullName = "Intel Simplified Software License"; shortName = "issl"; url = "https://software.intel.com/en-us/license/intel-simplified-software-license"; }
    platforms = with platforms; linux ++ darwin;
  };
}
