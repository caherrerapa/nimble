class Keyword < ApplicationRecord

  def self.import(file)
  spreadsheet = Roo::Spreadsheet.open(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    # keyword.attributes = row.to_hash
    # keyword = Keyword.where(id: keyword.attributes["id"]) || new
    # keyword.save!
    keyword_hash = row.to_hash # exclude the price field
      keywords = Keyword.where(word: keyword_hash["word"])
      if keywords.count == 1
        keywords.first.update_attributes(keyword_hash)
      else
        Keyword.create!(keyword_hash)
      end
  end
end

end
