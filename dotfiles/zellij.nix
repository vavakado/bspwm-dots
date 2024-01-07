{ ... }:
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };
  home.file.".config/zellij/config.kdl".text = ''
    theme "catppuccin-mocha"
    ui {
      pane_frames {
        rounded_corners true
      }
    }
  '';
}
