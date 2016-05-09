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

  ## Say what you're processing
  puts "\nProcessing: #{item}"

  ## Get filename
  puts "\nGetting basename..."
  filename = File.basename(item, '.*')
  
  ## Hash file contents
  puts "\nHashing file..."
  file = "books/#{item}"
  hash = Digest::MD5.file(file)

  ## Array for book info
  info = Array.new

  ## Get file name of item
  file_path = File.expand_path(File.dirname(__FILE__)) + "/../books/" + item

  ## If pdf, parse contents with docsplit
  if extension == 'pdf'
    # Get copyright date
    copyright = ParsePDF.copyright(file_path)
    
    # Parse for ISBN to fetch data
    isbn = ParsePDF.isbn(file_path)

    # Get length
    length = Docsplit.extract_length(file_path)

    # Default values
    title = nil
    author = nil
    publisher = nil
    category = nil

    # Operations dependent on isbn
    if isbn != nil
      ## Info grab
      info = fetch_info(isbn)
				title = info.at(0) 
				author = info.at(1) 
				publisher = info.at(2) 
				category = info.at(3)

      ## Clean up author names
      author = author_fix(info.at(1)) unless info.at(1) == nil

      ## Rename file
      filename = file_rename(item, info.at(0), extension) unless info.at(0) == nil
    end
  
    # Delete temp folder
    FileUtils.rm_rf('temp')
  end

  # Create record for each book
  Book.create(filename: filename, 
              extension: extension,
              isbn: isbn,
              published: copyright,
              booktype: booktype,
              length: length,
              shahash: hash,
              title: title,
              author: author,
              publisher: publisher,
              category: category)

  # Prints relevant info to console
  puts "\ntitle: #{title}"
  puts "isbn10: #{isbn}"
  puts "authors: #{author}"
  puts "publisher: #{publisher}"
  puts "subjects: #{category}"
  puts "filename: #{filename}"
  puts "hash: #{hash}"
end

# Fetch info and return as array
def fetch_info(isbn)
  ## Create array
  info = Array.new

  ## Start fetching information
  results = ISBNdb::Query.find_book_by_isbn(isbn)
  
  # Check if any results were fetched
  if not results.first.nil?
    ## Read information into array
    results.each do |result|
      info[0] = result.title 
      info[1] = result.authors_text 
      info[2] = result.publisher_name 
      info[4] = result.subject_ids 
    end
  else
    info[0] = nil
		info[1] = nil
		info[2] = nil
		info[3] = nil
  end

	## Return array
	return info
end

# Clean author name
def author_fix(author)
  author = author.split(",", 2)
  author = author.at(0).split("and", 2)
  author = author.at(0)
  return author
end

# Rename file
def file_rename(original_name, title, extension)
  ## Set filename to title
  filename = title
  ## Make filename lowercase
  filename = filename.downcase
  ## Replace nonword chars with
  ## underscores (standard delimiter)
  filename.gsub!(/\W+/, '_')
  ## Shovel '.ext' onto the end
  filename << ".#{extension}"
  ## Rename file
  File.rename("books/#{original_name}", "books/#{filename}")
  return filename
end
