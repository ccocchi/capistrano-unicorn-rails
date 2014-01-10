namespace :unicorn do
  def send_signal(sig)
    execute :kill, "-#{sig}", "`cat #{fetch(:unicorn_pid_path)}`"
  end

  desc "Start a fresh new unicorn server if not already running, otherwise restart the existing one"
  task :restart do
    on roles(:app, in: :sequence, wait: 5) do
      within release_path do
        if test("[ -s #{fetch(:unicorn_pid_path)} ]")
          send_signal('USR2')
        else
          execute :bundle, :exec, :unicorn_rails, '-D', '-E', fetch(:unicorn_rails_env), '-c', fetch(:unicorn_config_path)
        end
      end
    end
  end

  desc "Stop gracefully the unicorn server"
  task :stop do
    on roles(:app) do
      send_signal('QUIT')
    end
  end
end

namespace :load do
  task :defaults do
    set :unicorn_rails_env, ->{ fetch(:rails_env, fetch(:stage)) }
    set :unicorn_pid_path, ->{ File.join(current_path, 'tmp', 'pids', 'unicorn.pid') }
    set :unicorn_config_path, ->{ File.join(current_path, 'config', 'unicorn.rb') }
  end
end