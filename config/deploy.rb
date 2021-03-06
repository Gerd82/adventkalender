# config valid only for current version of Capistrano
lock '3.3.3'

set :application, 'adventkalender'
set :repo_url,    'https://github.com/Gerd82/adventkalender.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"

# Default value for :scm is :git
set :scm, :git
set :repo_url,    'https://github.com/Gerd82/adventkalender.git'

set :deploy_user, 'deployer'

set :rvm_path, "$HOME/.rvm"
set :rvm_ruby_string, "ruby-2.1.5@advent"
set :rvm_type, :user  # Don't use system-wide RVM

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

set :bundle_binstubs, nil
# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/unicorn.rb')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, []

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  nginx_advent.conf
  database.example.yml
  log_rotation
  unicorn.rb
  unicorn_init.sh
))

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
  unicorn_init.sh
))

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc.
set(:symlinks, [
  {
    source: "nginx_advent.conf",
    link: "/etc/nginx/sites-enabled/#{fetch(:full_app_name)}"
  },
  {
    source: "unicorn_init.sh",
    link: "/etc/init.d/unicorn_#{fetch(:full_app_name)}"
  },
  {
    source: "log_rotation",
   link: "/etc/logrotate.d/#{fetch(:full_app_name)}"
  }
])
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

# set :log_level, :max_level

namespace :deploy do
  # make sure we're deploying what we think we're deploying
  # before :deploy, "deploy:check_revision"

  # only allow a deploy with passing tests to deployed
  # before :deploy, "deploy:run_tests"

  # compile assets locally then rsync
  # after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  # before 'deploy:symlink:linked_dirs', 'deploy:setup_config'

  # remove the default nginx configuration as it will tend
  # to conflict with our configs.
  before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  after :setup_config, 'nginx:reload'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'

  after   :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
