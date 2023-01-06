package "rustup"

execute "rustup-init" do
  command "rustup-init -y"
  not_if "which rustup"
end