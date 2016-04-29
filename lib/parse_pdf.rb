class ParsePDF 

  # Parse for copyright date in first 10 pages 
  def self.copyright(file_path)
    copyright_regex = /Copyright.*$/
    Docsplit.extract_text(file_path, {pdf_opts: '-layout',  
                          pages: 1..10, 
                          output: 'temp'})
    Dir.foreach('temp') do |file|
      next if file == '.' or file =='..'
      filename = File.expand_path(File.dirname(__FILE__)) + "/../temp/" + file
      f = File.open(filename, 'r+')
      f.each_line do |line|
        if line.match(copyright_regex)
          return line[/\d\d\d\d/]
        end
      end
      f.close
    end
    # Return nil if nothing is found
    return nil
  end

  # Parse for ISBN in first 10 pages 
  def self.isbn(file_path)
    isbn_regex = /Copyright.*$/
    Docsplit.extract_text(file_path, {pdf_opts: '-layout',  
                          pages: 1..10, 
                          output: 'temp'})
    Dir.foreach('temp') do |file|
      next if file == '.' or file =='..'
      filename = File.expand_path(File.dirname(__FILE__)) + "/../temp/" + file
      f = File.open(filename, 'r+')
      f.each_line do |line|
        if line.match(isbn_regex)
          return line[/\d/]
        end
      end
      f.close
    end
    # Return nil if nothing is found
    return nil
  end
end
