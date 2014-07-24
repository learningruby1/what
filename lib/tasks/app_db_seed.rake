namespace :app do
  namespace :db do
    namespace :seed do
      Dir[File.join(Rails.root, 'db', 'documents', '*.rb')].each do |filename|
        desc "Seed #{ File.basename(filename, '.rb') } document"
        task_name = File.basename(filename, '.rb').intern
        task task_name => :environment do
          load(filename) if File.exist?(filename)
        end
      end
    end
  end
end