class MessageProcessor
  include ActiveModel::Model

  CSV_FILE_PATH = "#{Rails.root}/messages_#{Rails.env}.csv"
  VALID_CSV_HEADERS = %w{name email subject content}

  attr_accessor :name, :email, :subject, :content

  validates :name, :email, :subject, :content, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  # Import data from CSV file to the database
  # Row has data for two models Submitter and Message
  def self.import_to_db
    messages_imported = []
    SmarterCSV.process(CSV_FILE_PATH, chunl_size: 10) do |chunk|
      chunk.each do |row|
        submitter = import_submitter(row)
        messages_imported << import_message(row, submitter.id)
      end
    end
    File.truncate(CSV_FILE_PATH, 0)
    messages_imported
  rescue
    messages_imported
  end

  # Exporting data from the contact form into csv file
  def export_to_csv
    CSV.open(CSV_FILE_PATH, 'a+', headers: true) do |csv|
      csv << VALID_CSV_HEADERS unless csv.read.headers.present?
      csv << as_json.values_at(*VALID_CSV_HEADERS)
    end
  end

  private

  class << self
    def import_submitter(row)
      Submitter.where(email: row[:email]).first_or_create(
          name: row[:name],
          email: row[:email]
      )
    end

    def import_message(row, submitter_id)
      Message.create(
          subject: row[:subject],
          content: row[:content],
          submitter_id: submitter_id
      )
    end
  end
end
