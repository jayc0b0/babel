json.array!(@books) do |book|
  json.extract! book, :id, :title, :author, :published, :isbn, :cover
  json.url book_url(book, format: :json)
end
