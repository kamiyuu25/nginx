#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
#########################################################
## ユーザ作成
#########################################################

u = Chef::EncryptedDataBagItem.load('users', 'nginx')

group u["groups"] do
  action :create
end

user u['id'] do
  supports :managa_home => false
  uid u["uid"]
  gid u["groups"]
  shell u['shell']
  password u['password']
end


#########################################################
## セットアップ
#########################################################
include_recipe "yum-epel"

package "nginx" do
  action :install
end

service "nginx" do
  action [ :enable, :start ]
  supports :status => true, :restart => true, :reload => true
end

template 'nginx.conf' do
  path '/etc/nginx/nginx.conf'
  source "nginx.conf.erb"
  owner 'root'
  group 'root'
  mode '0664'
  notifies :reload, "service[nginx]"
end
