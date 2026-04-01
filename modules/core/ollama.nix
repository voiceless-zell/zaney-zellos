{ pkgs, ... }:
{
  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
    };
    nextjs-ollama-llm-ui = {
      enable = true;
    };
  };
}
