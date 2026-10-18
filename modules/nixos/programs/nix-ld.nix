{ ... }:

{
  # Install a stub /lib64/ld-linux-x86-64.so.2 so generic Linux executables
  # shipped inside PyPI wheels and npm packages (ninja for vLLM/FlashInfer JIT,
  # triton's ptxas, Biome, ...) can run. Dev shells such as
  # ~/nix-dev/python-cuda declare the libraries they need via
  # NIX_LD_LIBRARY_PATH; the module's default library set covers the rest.
  programs.nix-ld.enable = true;
}
