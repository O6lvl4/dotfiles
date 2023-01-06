package "openssl"

execute "tauri-mobile install" do
  command "cargo install --git https://github.com/tauri-apps/tauri-mobile"
  not_if "cargo mobile"
end