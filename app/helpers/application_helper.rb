module ApplicationHelper

  def get_begin_text(text, index)
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

  def get_index_hash(answers)
    number = answers.group_by(&:sort_index).count
    hash_index = Hash.new
    char = 97
    number.times do
      hash_index[char.chr] = 1
      char += 1
    end
    return hash_index
  end

  def get_number_of_child(document)
    answer = document.step_answers(8).last

    if answer.nil?
      return nil
    else
      return answer.answer
    end
  end

  def get_self(document)
    answers = document.step_answers(2)
    answer = answers[answers.count - 2]

    if answer.nil?
      return nil
    else
      return answer.answer
    end
  end
end
