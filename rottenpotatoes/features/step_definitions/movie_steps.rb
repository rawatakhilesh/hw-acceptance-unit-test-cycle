Given(/the following movies exist/) do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end    
end

Then (/^the director of "(.*)" should be "(.*)"/) do |field, value|
  movie = Movie.find_by(title: field)
  visit movie_path(movie)
  expect(page.body).to match(/Director:\s#{value}/)
end


