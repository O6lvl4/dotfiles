rbenv = "$HOME/.rbenv/bin/rbenv"
default_version = "2.7.6"

git File.expand_path("~/.rbenv") do
  repository "https://github.com/rbenv/rbenv.git"
end

git File.expand_path("~/.rbenv/plugins/ruby-build") do
  repository "https://github.com/sstephenson/ruby-build.git"
end

git File.expand_path("~/.rbenv/plugins/rbenv-update") do
  repository "https://github.com/rkh/rbenv-update.git"
end

execute "install ruby 2.x" do
  command "#{rbenv} install #{default_version}"
  not_if "#{rbenv} versions | grep #{default_version}"
end

execute "setup ruby 2.x for global setting" do
  command "#{rbenv} global #{default_version}"
  not_if "#{rbenv} versions | grep \"* #{default_version}\""
end
