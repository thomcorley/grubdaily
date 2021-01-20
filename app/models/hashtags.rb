class Hashtags
  class ArgumentError < StandardError; end

  class << self
    def general_tags
      file_contents = File.read("lib/hashtags/general.txt")
      file_contents.split("\n")
    end

    # prints a number of tags from the general list, defaulting to 11
    def print(number)
      raise ArgumentError unless number.is_a?(Integer)

      if number.nil?
        number = 11
      end

      output = ""
      general_tags.sample(number).each do |tag|
        output << "##{tag} "
      end
      output.strip
    end
  end
end
