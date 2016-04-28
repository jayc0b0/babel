# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'digest'

# Create arrays for categorization
book_type = ['pdf', 'epub', 'mobi', 'doc', 'docx', 'chm', 'azw3', 'azw',
             'kf8', 'txt', 'rtf']
comic_type = ['cbr', 'cbz', 'cbt', 'cba', 'cb7']

Dir.foreach('books') do |item|
  next if item == '.' or item == '..'

  # Automatically extract info from file 
  ## Check extension and determine if comic or book
  extension = File.extname(item)[1..-1]
  if book_type.include? extension
    category = 'book'
  elsif comic_type.include? extension
    category = 'comic'
  else
    next
  end
  ## Get filename
  filename = File.basename(item, '.*')
  
  # Hash file contents
  file = "books/#{item}"
  sha256 = Digest::SHA256.file file
  shahash = sha256.hexdigest

  # If pdf, parse contents with docsplit
  if extension == 'pdf'
    file_path = File.expand_path(File.dirname(__FILE__)) + "/../books/" + item
    #Docsplit.extract_text(file_path, {pdf_opts: '-layout',  
    #  										pages: 0..5, 
    #  										output: page_text})
    length = Docsplit.extract_length(file_path)
  end

  # Create record for each book
  Book.create(filename: filename, 
              extension: extension,
              category: category,
              #published: copyright,
              length: length,
              shahash: shahash)

end
