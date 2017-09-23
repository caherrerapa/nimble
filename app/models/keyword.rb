class Keyword < ApplicationRecord

  belongs_to :user

  def self.import(file, user_id)
  spreadsheet = Roo::Spreadsheet.open(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    keyword_hash = row.to_hash
      keywords = Keyword.where(word: keyword_hash["word"])
      if keywords.count == 1 #checks to see if there is a keyword of it already
        keywords.first.update_attributes(keyword_hash)
      else
        Keyword.create!(keyword_hash) #if there is no record of the keyword, create it.
      end
end
end

end
