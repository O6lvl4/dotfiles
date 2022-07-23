execute "setup homebrew" do
  command 'arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"'
  not_if "which brew"
end