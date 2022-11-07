directory File.expand_path("~/.aws") do
  action :create
end

link File.expand_path("~/.aws/config") do
  to File.expand_path("cookbooks/aws/files/.aws/config")
  force true
end

# https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2-mac.html
execute "install awscli@v2" do
  command <<~EOF
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /
    rm AWSCLIV2.pkg
  EOF
  not_if "which aws"
end

execute "install cdk" do
  command "volta install aws-cdk"
  not_if "which cdk"
end

execute "install amplify" do
  command "volta install @aws-amplify/cli"
  not_if "which amplify"
end