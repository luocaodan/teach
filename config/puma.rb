# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart


# workers 设置为 CPU 核心数
workers 2
threads 1, 6
# 后台运行
daemonize true
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"
bind "unix://#{shared_dir}/sockets/puma.sock"
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end
