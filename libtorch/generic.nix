{ stdenv, fetchzip, autoreconfHook, gettext
, version ? "1.2", mkSrc, buildtype
#, cudaSupport ? false, cudatoolkit ? null, cudnn ? null
#, mklSupport ? false
, mkl ? null
}:

stdenv.mkDerivation rec {
  name = "libtorch-${version}";
  inherit version;

  src = mkSrc buildtype;

  propagatedBuildInputs =
    if stdenv.isDarwin then [ mkl ]
    else [];

#    ++ stdenv.lib.optionals cudaSupport [ cudatoolkit cudnn ];
#    ++ stdenv.lib.optionals mklSupport [ mkl ];
  preFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change @rpath/libshm.dylib $out/lib/libshm.dylib $out/lib/libtorch_python.dylib
    install_name_tool -change @rpath/libtorch.dylib $out/lib/libtorch.dylib $out/lib/libtorch_python.dylib
    install_name_tool -change @rpath/libc10.dylib $out/lib/libc10.dylib $out/lib/libtorch_python.dylib
    install_name_tool -change @rpath/libc10.dylib $out/lib/libc10.dylib $out/lib/libtorch.dylib
    install_name_tool -change @rpath/libtorch.dylib $out/lib/libtorch.dylib $out/lib/libcaffe2_observers.dylib
    install_name_tool -change @rpath/libc10.dylib $out/lib/libc10.dylib $out/lib/libcaffe2_observers.dylib
    install_name_tool -change @rpath/libtorch.dylib $out/lib/libtorch.dylib $out/lib/libcaffe2_module_test_dynamic.dylib
    install_name_tool -change @rpath/libc10.dylib $out/lib/libc10.dylib $out/lib/libcaffe2_module_test_dynamic.dylib
    install_name_tool -change @rpath/libtorch.dylib $out/lib/libtorch.dylib $out/lib/libcaffe2_detectron_ops.dylib
    install_name_tool -change @rpath/libc10.dylib $out/lib/libc10.dylib $out/lib/libcaffe2_detectron_ops.dylib
    install_name_tool -change @rpath/libtorch.dylib $out/lib/libtorch.dylib $out/lib/libshm.dylib
    install_name_tool -change @rpath/libc10.dylib $out/lib/libc10.dylib $out/lib/libshm.dylib
    install_name_tool -change @rpath/libmklml.dylib $mkl/lib/libmklml.dylib $out/lib/libtorch.dylib
    install_name_tool -change @rpath/libiomp5.dylib $mkl/lib/libiomp5.dylib $out/lib/libtorch.dylib
  '';
  installPhase = ''
    ls $src
    mkdir $out
    cp -r {$src,$out}/bin/
    cp -r {$src,$out}/include/
    cp -r {$src,$out}/lib/
    cp -r {$src,$out}/share/
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
