# Capistrano::Unicorn

Unicorn basic tasks for Capistrano v3:

- `cap unicorn:restart`
- `cap unicorn:stop`

There is no `start` task since Capistrano v3 only use `restart`. The `unicorn:restart`
will handle both the start and the restart of the unicorn server.

Some unicorn specific options

```ruby
set :unicorn_rails_env, ->{ fetch :rails_env, "production" }
set :unicorn_pid_path, ->{ File.join(current_path, 'tmp', 'pids', 'unicorn.pid') }
set :unicorn_config_path, ->{ File.join(current_path, 'config', 'unicorn.rb') }
```

The task will use the `unicorn_rails` binary to avoid unnecessary middleware added by
the `unicorn` binary (Rails already take care of that)

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-unicorn-rails'

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
