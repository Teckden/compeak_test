namespace :db do
  desc 'Import messages from CSV file'
  task :import_messages => :environment do
    puts 'Starting to import messages from csv file'
    messages = MessageProcessor.import_to_db
    puts "#{messages.count} messages have been successfully imported"
  end
end
