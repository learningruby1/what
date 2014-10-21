namespace :app do
  namespace :db do
    desc 'Makes DB empty (no data, just tables)'
    task :clear do
      on roles(:all) do
        within release_path do
          execute :rake, 'app:db:clear'
        end
      end
    end

    desc 'Load the seed data from db/documents directory'
    task :seed do
      on roles(:all) do
        within release_path do
          Dir.glob("db/documents/*.rb").each do |filename|
            execute :rake, "app:db:seed:#{File.basename(filename, ".rb")}"
          end
        end
      end
    end

    desc 'Clear DB and load the seed data from db/seeds.rb'
    task :clear_and_seed do
      on roles(:all) do
        within release_path do
          execute :rake, 'app:db:clear'
          execute :rake, 'db:seed'
        end
      end
    end
  end
end
