class ParsePDF 

  # Parse for ISBN in first 10 pages 
  def self.isbn(file_path)
    isbn_regex = /\d+-\d+-\d+-\d+/
    Docsplit.extract_text(file_path, {pdf_opts: '-layout',  
                          pages: 1..10, 
                          output: 'temp'})
    Dir.foreach('temp') do |file|
      next if file == '.' or file =='..'
      filename = File.expand_path(File.dirname(__FILE__)) + "/../temp/" + file
      f = File.open(filename, 'r+')
      f.each_line do |line|
        if line.match(isbn_regex)
          isbn = line[isbn_regex]
          # Clean up isbn
          isbn.downcase!
          isbn.slice!(':')
          isbn.slice!('isbn')
          isbn.tr!('-','')
          isbn.strip!
          return isbn
        end
      end
      f.close
    end
    # Return nil if nothing is found
    return nil
  end

end
