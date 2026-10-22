{
  config,
  paths,
  pkgs,
  ...
}:

{
  # Keep inference available on demand without a persistent service; use the
  # CUDA build only where the NVIDIA driver is loaded.
  hm.home.packages = [
    (if config.hardware.nvidia.enabled then pkgs.ollama-cuda else pkgs.ollama)
  ];

  # Store Ollama blobs alongside the user's other local models.
  hm.home.sessionVariables.OLLAMA_MODELS = paths.user.ollamaModelsDirectory;
}
