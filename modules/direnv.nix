{ config, pkgs, ... }:

{
  # Включаем direnv и интеграцию с nix-direnv для кэширования
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    
    # Автоматическая интеграция с основными оболочками
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # Дополнительная интеграция для оболочки Fish (если используется)
  programs.fish = {
    interactiveShellInit = ''
      # Активация direnv в fish, если она не подхватилась автоматически
      if type -q direnv
        direnv hook fish | source
      end
    '';
  };
}

