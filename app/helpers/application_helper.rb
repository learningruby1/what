module ApplicationHelper

  def get_beginText(text, index)
    if text.match(/<beginText\/>/)
      tmp_array = text.split('<beginText/>').first.split('/')
      tmp_array[0] = "#{tmp_array.first} #{index}"
      tmp_array[1] = "#{tmp_array.second} #{index}"
      tmp_array << text.split('<beginText/>').last
      return tmp_array
    else
      return nil
    end
  end

  def get_index_hush(answers)
    number = answers.group_by(&:sort_index).count
    hash_index = Hash.new
    char = 97
    number.times do
      hash_index[char.chr] = 1
      char += 1
    end
    return hash_index
  end
end
