# Capistrano::Unicorn

Unicorn basic tasks for Capistrano v3:

- `cap unicorn:restart`
- `cap unicorn:stop`

There is no `start` task since Capistrano v3 only use `restart`. The `unicorn:restart`
will handle both the start and the restart of the unicorn server.

Some unicorn specific options

```ruby
set :unicorn_rails_env, ->{ fetch :rails_env, "production" }
set :unicorn_pid_path, ->{ nil }
set :unicorn_config_dir,  'config'
set :unicorn_config_file, 'unicorn.rb'  
```

`unicorn_pid_path` is the only mandatory variable to set, `unicorn:restart` is using it
to know whether or not unicorn is already running.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano3-unicorn'

## Usage

Require `capistrano/unicorn` inside your `Capfile` to load all tasks.

By default, no task are automatically added since Capistrano will remove the default `deploy:restart` its version 3.1.
You'll need to invoke directly the task inside your `config/deploy.rb`

```ruby
namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end 
end
```

or

```ruby
after 'deploy:published', 'unicorn:restart'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
