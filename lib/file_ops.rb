require 'digest'
require 'parse_pdf'
require 'isbndb'

# Add book to database
def add_book(item)
  # Automatically extract info from file 

	## Create arrays for categorization
	book_type = ['pdf', 'epub', 'mobi', 'doc', 'docx', 'chm', 'azw3', 'azw',
							 'kf8', 'txt', 'rtf']
	comic_type = ['cbr', 'cbz', 'cbt', 'cba', 'cb7']

  ## Check extension and determine if comic or book
  extension = File.extname(item)[1..-1]
  if book_type.include? extension
    booktype = 'book'
  elsif comic_type.include? extension
    booktype = 'comic'
  else
    return nil
  end

  ## Get filename
  filename = File.basename(item, '.*')
  ## Convert to lowercase
  
  ## Hash file contents
  file = "books/#{filename}.#{extension}"
  shahash = Digest::SHA256.hexdigest File.read file

  # Array for book info
  info = Array.new

  ## If pdf, parse contents with docsplit
  if extension == 'pdf'
    # Get file name of item
    file_path = File.expand_path(File.dirname(__FILE__)) + "/../books/" + item

    # Get copyright date
    copyright = ParsePDF.copyright(file_path)
    
    # Parse for ISBN to fetch data
    ## Grab ISBN and pass to ISBNdb gem
    isbn = ParsePDF.isbn(file_path)

    ## Start fetching information
    results = ISBNdb::Query.find_book_by_isbn(isbn)
    
    ## Read information into array
    results.each do |result|
      info[0] = result.title 
      info[1] = result.authors_text 
      info[2] = result.publisher_name 
      info[4] = result.subject_ids 
    end

    # Sanitization of data
    ## Clean up author names (ADD THIS)

    # Get length
    length = Docsplit.extract_length(file_path)
  
    # Delete temp folder
    FileUtils.rm_rf('temp')
  end

  # Rename file
  ## Set filename to title
  filename = info.at(0)
  ## Make filename lowercase
  filename = filename.downcase
  ## Replace nonword chars with
  ## underscores (standard delimiter)
  filename.gsub!(/\W+/, '_')
  ## Shovel '.ext' onto the end
  filename << ".#{extension}"
  ## Rename file
  File.rename("books/#{item}", "books/#{filename}")

  # Create record for each book
  Book.create(filename: filename, 
              extension: extension,
              isbn: isbn,
              published: copyright,
              booktype: booktype,
              length: length,
              shahash: shahash,
              title: info.at(0),
              author: info.at(1),
              publisher: info.at(2),
              category: info.at(3))

  # Prints relevant info to console
  puts "\ntitle: #{info.at(0)}"
  puts "isbn10: #{isbn}"
  puts "authors: #{info.at(1)}"
  puts "publisher: #{info.at(2)}"
  puts "subjects: #{info.at(3)}"
  puts "filename: #{filename}"
  puts "hash: #{shahash}"
end
