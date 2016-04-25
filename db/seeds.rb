# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'digest'

Dir.foreach('books') do |item|
  next if item == '.' or item == '..'
  file = "books/#{item}"
  sha256 = Digest::SHA256.file file
  Book.create(filename: File.basename(item, '.*'), extension: File.extname(item)[1..-1], shahash: sha256.hexdigest)
end
