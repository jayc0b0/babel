class Book < ActiveRecord::Base
  # Obfuscate ID's
  obfuscate_id

  # Field options
  serialize :category
end
