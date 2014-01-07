namespace :unicorn do
  def send_signal(sig)
    execute :kill, "-#{sig}", "`cat #{fetch(:unicorn_pid_path)}`"
  end

  desc "Make sure capistrano3-unicorn configuration is valid"
  task :check_configuration do
    on roles(:app) do
      error 'unicorn_pid_path is not set, please make sure to add it to your configuration' if fetch(:unicorn_pid_path).nil?
    end
  end

  desc "Start a fresh new unicorn server if not already running, otherwise restart the existing one"
  task :restart do
    invoke 'unicorn:check_configuration'
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
    set :unicorn_rails_env, ->{ fetch :rails_env, "production" }
    set :unicorn_rack_env,  ->{
      fetch(:rails_env) == 'production' ? 'deployment' : 'development'
    }    

    set :unicorn_user, ->{ nil }
    set :unicorn_pid_path, ->{ nil }

    set :unicorn_config_dir,  'config'
    set :unicorn_config_file, 'unicorn.rb'
    set :unicorn_config_path, ->{
      [release_path, fetch(:unicorn_config_dir), fetch(:unicorn_config_file)].join('/')
    }    
  end
end