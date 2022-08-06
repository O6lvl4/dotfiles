git File.expand_path("~/.direnv") do
  repository "https://github.com/direnv/direnv.git"
  not_if "which direnv"
end

install_url = "https://direnv.net/install.sh"
execute "direnv install" do
  command "curl -sfL #{install_url} | bash"
  not_if "which direnv"
end