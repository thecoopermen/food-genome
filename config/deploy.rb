require "bundler/capistrano"

# additional recipes to load
load "config/recipes/base"
load "config/recipes/deployer"
load "config/recipes/rbenv"
load "config/recipes/libxml"
load "config/recipes/imagemagick"
load "config/recipes/nginx"
load "config/recipes/nodejs"
load "config/recipes/passenger"
load "config/recipes/mysql"
load "config/recipes/redis"
# load "config/recipes/newrelic"

# setup for multistage deployments
set :stages, %w( production )
set :default_stage, "production"
require 'capistrano/ext/multistage'

# general deployment settings
set :user,        "deploy"
set :application, "food-genome"
set :rails_env,   "production"
set :deploy_to,   "/data/#{application}"
set :deploy_via,  :remote_cache
set :use_sudo,    false

# source control settings
set :scm,        "git"
set :repository, "git@github.com:thecoopermen/#{application}.git"
set :branch,     "master"

# avoid having to set up deploy keys by using SSH key forwarding
default_run_options[:pty]   = true
ssh_options[:forward_agent] = true
