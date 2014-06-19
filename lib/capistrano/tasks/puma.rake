# namespace :puma do
#   desc 'Start puma'
#   task :start do
#     on roles(:all) do
#       execute :cd, '/home/formsmama/www/formsmama/bundle exec puma -w 3 -d -e production -b unix://#{shared_path}/pids/formsmama-puma.sock -S #{shared_path}/pids/state --pidfile #{shared_path}/pids/pid'
#     end
#   end

#   desc 'Stop puma'
#   task :stop do
#     on roles(:app) do
#       run <<-CMD
#         echo #{shared_path}
#         kill formsmama/www/formsmama/shared/pids/pid
#         rm -f #{shared_path}/pids/pid #{shared_path}/pids/state #{shared_path}/pids/formsmama-puma.sock
#       CMD
#     end
#   end

#   desc 'Restart puma'
#   task :restart do
#     on roles(:all) do
#       stop
#       start
#     end
#   end
# end