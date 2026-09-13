{ paths, pkgs, ... }:

{
  # Keep CUDA inference available on demand without a persistent service.
  home.packages = [ pkgs.ollama-cuda ];

  # Store Ollama blobs alongside the user's other local models.
  home.sessionVariables.OLLAMA_MODELS = paths.user.ollamaModelsDirectory;
}
