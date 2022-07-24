execute "setup homebrew" do
  install_url = "https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
  command "arch -x86_64 /bin/bash -c \"$(curl -fsSL #{install_url})\""
  not_if "which brew"
end
