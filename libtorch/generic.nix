{ stdenv, fetchzip, autoreconfHook, gettext
, version ? "1.2", mkSrc, buildtype
#, cudaSupport ? false, cudatoolkit ? null, cudnn ? null
#, mklSupport ? false , mkl ? null
}:

stdenv.mkDerivation rec {
  name = "libtorch-${version}";
  inherit version;

  src = mkSrc buildtype;

  propagatedBuildInputs = [];
#    ++ stdenv.lib.optionals cudaSupport [ cudatoolkit cudnn ];
#    ++ stdenv.lib.optionals mklSupport [ mkl ];
  installPhase = ''
    ls $src
    mkdir $out
    cp -r {$src,$out}/bin/
    cp -r {$src,$out}/include/
    cp -r {$src,$out}/lib/
    cp -r {$src,$out}/share/
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -id @rapth/libtorch.dylib $out/lib/libtorch.dylib
    install_name_tool -id @rapth/libc10.dylib $out/lib/libc10.dylib
  '';

  # postInstall = ''
  #   # Make boost header paths relative so that they are not runtime dependencies
  #   cd "$dev" && find include \( -name '*.hpp' -or -name '*.h' -or -name '*.ipp' \) \
  #     -exec sed '1i#line 1 "{}"' -i '{}' \;
  # '';

  meta = with stdenv.lib; {
    description = "libtorch";
    homepage = https://pytorch.org/;
    license = licenses.bsd3;
    platforms = with platforms; linux ++ darwin;
  };
}
