class ParsePDF 
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

    return nil
  end
end
