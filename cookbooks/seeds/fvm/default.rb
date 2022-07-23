default_version = "3.0.5"

execute "tap fvm" do
  command "brew tap leoafarias/fvm"
  not_if "brew list | grep fvm"
end

package "fvm" do
  not_if "which fvm"
end

execute "fvm flutter install default version" do
  command "fvm install #{default_version}"
  not_if "fvm list | grep #{default_version}"
end

execute "setup flutter" do
  command "fvm global #{default_version}"
  not_if "fvm flutter --version"
end
