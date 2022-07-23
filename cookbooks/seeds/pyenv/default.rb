pyenv = "$HOME/.pyenv/bin/pyenv"
default_version = "3.9.13"

git File.expand_path("~/.pyenv") do
  repository "https://github.com/pyenv/pyenv.git"
end

execute "setup python 3.x" do
  command "#{pyenv} install #{default_version}"
  not_if "#{pyenv} versions | grep #{default_version}"
end
