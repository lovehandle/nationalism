require "bundler/capistrano"

#========================
#CONFIG
#========================
set :application, "ameriCAN"
 
set :scm, :git
set :git_enable_submodules, 1
set :repository, "git@github.com:rclosner/nationalism"
set :branch, "master"
set :ssh_options, { :forward_agent => true }
 
set :stage, :production
set :user, "deploy"
set :use_sudo, false
set :runner, "deploy"
set :deploy_to, "/var/www/ryan_closner"
set :app_server, :passenger
set :domain, "ryanclosner.com"

set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

#========================
#ROLES
#========================
role :app, domain
role :web, domain
role :db, domain, :primary => true

#========================
#CUSTOM
#========================
 
namespace :deploy do
  desc "Start Application"
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
 
  desc "Stop Application"
  task :stop, :roles => :app do
    # Do nothing.
  end
 
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :finalize_update, :except => { :no_release => true } do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't save empty folders
    run <<-CMD
      rm -rf #{latest_release}/log &&
      mkdir -p #{latest_release}/tmp &&
      ln -s #{shared_path}/log #{latest_release}/log
    CMD

    if fetch(:normalize_asset_timestamps, true)
      stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
      asset_paths = %w(img css).map { |p| "#{latest_release}/public/#{p}" }.join(" ")
      run "find #{asset_paths} -exec touch -t #{stamp} {} ';'; true", :env => { "TZ" => "UTC" }
    end
  end
end
