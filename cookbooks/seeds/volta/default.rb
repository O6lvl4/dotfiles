default_version = "16.16.0"
volta = "$HOME/.volta/bin/volta"

execute "setup volta" do
  install_url = "https://get.volta.sh"
  command "curl #{install_url} | bash"
  not_if "which #{volta}"
end

execute "install default version" do
  command "#{volta} install node@#{default_version}"
  not_if "#{volta} list | grep 'Node: v16.16.0'"
end