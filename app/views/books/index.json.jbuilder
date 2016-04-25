json.array!(@books) do |book|
  json.extract! book, :id, :title, :author, :filename, :isbn, :publisher, :cover, :hash
  json.url book_url(book, format: :json)
end
