# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'digest'
require 'parse_pdf'
require 'isbndb'

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
    booktype = 'book'
  elsif comic_type.include? extension
    booktype = 'comic'
  else
    next
  end
  ## Get filename
  filename = File.basename(item, '.*')
  
  ## Hash file contents
  file = "books/#{item}"
  sha256 = Digest::SHA256.file file
  shahash = sha256.hexdigest

  info = Array.new

  # If pdf, parse contents with docsplit
  if extension == 'pdf'
    # Get file name of item
    file_path = File.expand_path(File.dirname(__FILE__)) + "/../books/" + item
    
    # Parse for ISBN to fetch data
    ## Grab ISBN and pass to ISBNdb gem
    isbn = ParsePDF.isbn(file_path)

    # Start fetching information
    set = ISBNdb::Query.find_book_by_isbn(isbn).first
    
    # Read information into array
    info[0] = set.title 
    info[1] = set.authors_text 
    info[2] = set.publisher_name 
    info[4] = set.subject_ids 

    # Get length
    length = Docsplit.extract_length(file_path)
  
    # Delete temp folder
    FileUtils.rm_rf('temp')
  end

  # Create record for each book
  Book.create(filename: filename, 
              title: info.at(0),
              author: info.at(1),
              extension: extension,
              category: info.at(3),
              isbn: isbn,
              publisher: info.at(2),
              booktype: booktype,
              length: length,
              shahash: shahash)

end
