namespace :unicorn do
  def send_signal(sig)
    execute :kill, "-#{sig}", "`cat #{fetch(:unicorn_pid_path)}`"
  end

  desc "Make sure eveything is present"
  task :check do
    warn 'unicorn_pid_path is not set, please make sure to add it to your configuration' unless any?(:unicorn_pid_path)
  end

  desc "Start a new Unicorn server"
  task :start do
    invoke 'unicorn:check'
    on roles :app do
      within release_path do
        execute :bundle, :exec, :unicorn_rails, '-D', '-E', fetch(:unicorn_rails_env), '-c', fetch(:unicorn_config_path)
      end
    end
  end

  desc "Try to start a fresh unicorn server, and if successfull kill the old one"
  task :restart do
    send_signal('USR2')
  end

  desc "Stop gracefully the unicorn server"
  task :stop do
    send_signal('QUIT')
  end
end

namespace :load do
  task :defaults do
    set :unicorn_rails_env, -> { fetch :rails_env, "production" }
    set :unicorn_rack_env do
      fetch(:rails_env) == 'production' ? 'deployment' : 'development'
    end

    set :unicorn_user, -> { nil }
    set :unicorn_pid_path, -> { nil }

    set :unicorn_config_dir,  'config'
    set :unicorn_config_file, 'unicorn.rb'
    set :unicorn_config_path do
      [fetch(:release_path), fetch(:unicorn_config_dir), fetch(:unicorn_config_file)].join('/')
    end
  end
end