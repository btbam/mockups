
include_recipe "nginx"
include_recipe "nodejs::default"
include_recipe "nodejs::npm"


template "#{node[:nginx][:dir]}/sites-available/mockups" do
  source "mockup-site.erb"
  owner "root"
  group "root"
  mode 0644
end

nginx_site "mockups" do
  enable true
end

nginx_site "default" do
  enable false
end

%w(mongodb@0.7.9 nodeunit@0.5.0 socket.io@0.6.15).each do |name|
  execute "npm installation of #{name}" do
    command "npm install #{name}"
    only_if { ::File.exists?("/usr/local/bin/npm@#{node[:nodejs][:npm]}") }
  end
end


