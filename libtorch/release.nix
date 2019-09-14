{ pkgs ? import ../pin/nixpkgs.nix {} }:

with pkgs;

let
  callCpu = opts: callPackage ./generic.nix ({
#    mklSupport = true;
  } // opts);
  callGpu = opts: callPackage ./generic.nix ({
#    mklSupport = true;
    cudaSupport = true;
  } // opts);
in

{
  libtorch_cpu = callCpu {
    version = "1.1";
    mkSrc = buildtype:
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchzip {
          url = "https://download.pytorch.org/libtorch/${buildtype}/libtorch-cxx11-abi-shared-with-deps-1.2.0.zip";
          sha256 = "09iwdy31zg9dzkrjx8mwpds9mxrv775msn01v1njkpjymvi7llz6";
        }
      else if stdenv.hostPlatform.system == "x86_64-darwin" then
        fetchzip {
          url = "https://download.pytorch.org/libtorch/${buildtype}/libtorch-macos-1.2.0.zip";
          sha256 = "03wqgvmyz2dv5iin27rnhxy6blk7gf0h49vgwmnab9c5j43y2y3d";
        }
      else throw "missing url for platform ${stdenv.hostPlatform.system}";
  };
  libtorch_cudatoolkit_10_0 = callGpu {
    version = "1.1";
    mkSrc = buildtype:
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchzip {
          url = "https://download.pytorch.org/libtorch/${buildtype}/libtorch-cxx11-abi-shared-with-deps-1.2.0.zip";
          sha256 = "0wl9xnv6bbpp0f93iwidvf7n1ns2nbd8ykyc9r163s3f04l295k3";
        }
      else throw "missing url for platform ${stdenv.hostPlatform.system}";
    cudatoolkit = cudatoolkit_10_0;
    cudnn = cudnn_cudatoolkit_10_0;
  };
  libtorch_cudatoolkit_9_2 = callGpu {
    version = "1.2";
    mkSrc = buildtype:
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchzip {
          url = "https://download.pytorch.org/libtorch/${buildtype}/libtorch-cxx11-abi-shared-with-deps-1.2.0.zip";
          sha256 = "0wl9xnv6bbpp0f93iwidvf7n1ns2nbd8ykyc9r163s3f04l295k3";
        }
      else throw "missing url for platform ${stdenv.hostPlatform.system}";
    cudatoolkit = cudatoolkit_9_2;
    cudnn = cudnn_cudatoolkit_9_2;
  };
}
