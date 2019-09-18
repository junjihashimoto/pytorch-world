{ pkgs ? import ../pin/nixpkgs.nix {} }:

with pkgs;

let
  libmklml = opts: callPackage ./mklml.nix ({
  } // opts);
  callCpu = opts: callPackage ./generic.nix ({
#    mklSupport = true;
#    buildtype = "cpu";
     mkl = libmklml;
  } // opts);
  callGpu = opts: callPackage ./generic.nix ({
#    mklSupport = true;
#    cudaSupport = true;
#    buildtype = "cu100";
     mkl = libmklml;
  } // opts);
in
{
  inherit libmklml;
  libtorch_cpu = callCpu {
    version = "1.2";
    buildtype = "cpu";
    mkSrc = buildtype:
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchzip {
          url = "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-1.2.0.zip";
          sha256 = "0vh5fw9h1rydp2bbrlkq54z29p1v0lpfmllddk82sgz7sr3jld66";
        }
      else if stdenv.hostPlatform.system == "x86_64-darwin" then
        fetchzip {
          url = "https://download.pytorch.org/libtorch/cpu/libtorch-macos-1.2.0.zip";
          sha256 = "0qglhy7dpjxcn24q41wp0n8dflypbmfk6mqzafavi2jfhl33wac2";
        }
      else throw "missing url for platform ${stdenv.hostPlatform.system}";
  };
  libtorch_cudatoolkit_10_0 = callGpu {
    version = "1.2";
    buildtype = "cu100";
    mkSrc = buildtype:
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchzip {
          url = "https://download.pytorch.org/libtorch/cu100/libtorch-cxx11-abi-shared-with-deps-1.2.0.zip";
          sha256 = "1xr91pm5w6w62277lkcz5wnnqm28a62xydx9ak4c1p3jrp0g39gk";
        }
      else throw "missing url for platform ${stdenv.hostPlatform.system}";
#    cudatoolkit = cudatoolkit_10_0;
#    cudnn = cudnn_cudatoolkit_10_0;
  };
  libtorch_cudatoolkit_9_2 = callGpu {
    version = "1.2";
    buildtype = "cu92";
    mkSrc = buildtype:
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchzip {
          url = "https://download.pytorch.org/libtorch/cu92/libtorch-cxx11-abi-shared-with-deps-1.2.0.zip";
          sha256 = "0xsq7fw2d36wsfha04dcdd5fwi24h8hg7hqkd7l29g1cpfcvr4na";
        }
      else throw "missing url for platform ${stdenv.hostPlatform.system}";
#    cudatoolkit = cudatoolkit_9_2;
#    cudnn = cudnn_cudatoolkit_9_2;
  };
}
