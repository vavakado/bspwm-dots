{ ... }:
{
  home.file = {
    
    ".config/helix/config.toml".text = ''
      theme="kanagawa_trans"

      [editor]
      line-number = "relative"
      mouse = false
      completion-trigger-len = 2
      shell = ["bash", "-c"]
      auto-save = true
      bufferline = "multiple"
      true-color = true

      [editor.lsp]
      display-messages = true
      display-inlay-hints = true

      [editor.cursor-shape]
      insert = "bar"
      normal = "block"
      select = "underline"

      [editor.file-picker]
      hidden = false

      [editor.statusline]
      mode.normal = "NORMAL"
      mode.insert = "INSERT"
      mode.select = "SELECT"
      left = ["mode", "separator", "file-name"]
      center = ["spinner"]
      right = ["diagnostics", "selections", "position", "file-encoding"]
      separator = "|"
    '';
    ".config/helix/runtime/themes/kanagawa_trans.toml".text = ''
      inherits = "kanagawa"
      "ui.background" = { fg = "foreground" }
    '';
  };
}
