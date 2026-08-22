# Ollama - local LLM runtime
# Runs as a systemd service listening on 127.0.0.1:11434 (the default).
# Used by local AI apps (e.g. the A2A demo in ~/repos/langchain).
{ pkgs, ... }:

{
  services.ollama = {
    enable = true;

    # GPU acceleration via CUDA for the RTX 3080 Ti.
    # (`services.ollama.acceleration` was removed upstream; select the CUDA
    # build of the package instead. Unfree CUDA is allowed globally.)
    package = pkgs.ollama-cuda;

    # Declaratively pull models at activation time. The first rebuild after
    # adding a model here downloads it (qwen2.5:7b is ~4.7 GB) via the
    # ollama-model-loader oneshot service. Remove an entry and rebuild to stop
    # managing it (it won't delete already-pulled weights).
    loadModels = [
      "qwen2.5:7b"
    ];
  };
}
