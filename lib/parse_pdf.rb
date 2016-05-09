class ParsePDF 

  # Parse for ISBN in first 10 pages 
  def self.isbn(file_path)
    puts"\nBeginning text extraction..."
    Docsplit.extract_text(file_path, {pdf_opts: '--no-ocr --no-clean',  
                          pages: 1..10, 
                          output: 'temp'})
    puts "\nProcessed pdf into text"
    Dir.foreach('temp') do |file|
      next if file == '.' or file =='..'
      filename = File.expand_path(File.dirname(__FILE__)) + "/../temp/" + file
      f = File.open(filename, 'r+')
      f.each_line do |line|
        begin
          if ISBN.from_string(line) and ISBN.valid?(ISBN.from_string(line))
						isbn = ISBN.from_string(line)
						isbn = ISBN.ten(isbn)
						# Clean up isbn
						isbn.tr!('-','')
						isbn.strip!
            puts "\nFound ISBN"
						return isbn
          end
        rescue
        end
      end
      f.close
    end
    # Return nil if nothing is found
    puts "\nNo ISBN found"
    return nil
  end

  # Parse for Copyright Date in first 10 pages
  def self.copyright(file_path)
    copyright_regex = /Copyright.*$/
    copyright_regex_2 = /Published.*$/
    Docsplit.extract_text(file_path, {pdf_opts: '-layout --ocr',  
                          pages: 1..10, 
                          output: 'temp'})
    Dir.foreach('temp') do |file|
      next if file == '.' or file =='..'
      filename = File.expand_path(File.dirname(__FILE__)) + "/../temp/" + file
      f = File.open(filename, 'r+')
      f.each_line do |line|
        if line.match(copyright_regex) or line.match( copyright_regex_2)
          return line[/\d\d\d\d/]
        end
      end
    end
    # Return nil if nothing is found
    return nil
  end
end
