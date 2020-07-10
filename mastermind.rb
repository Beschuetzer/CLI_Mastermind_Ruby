require 'io/console'


class MastermindGame
  @@pattern_choosers = {
    computer: 0,
    human: 1,
  }
  @@colors = %w(green white red brown magenta cyan)

  def initialize(number_of_guesses, pattern_length)
    raise "pattern_length must be 6 or lower" if pattern_length > 6
    @number_of_guesses = number_of_guesses
    @pattern_length = pattern_length  
    @guesses = []
    @feedbacks = []
    @guesses_left = number_of_guesses
    @is_a_winner = false
  end

  def play
    @i = 0
    display_instructions.include?('y') ? get_pattern(0) : get_pattern(1)
    while true
      puts "\nGUESSING PHASE:\n".send(@@colors[0]) if @i == 0
      get_guess
      if @guesses_left > 0 && @is_a_winner == false
        display_game
      else
        break
      end
      @i += 1
    end
    puts "Codemakers prevail this time!\n"if @guesses_left <= 0
  end
  
  private
  def display_game
    puts "\nGuesses Remaining: #{@guesses_left}".send(@@colors[0])
    @guesses.each_index{|index1|
      print "\nGuess #{index1+1}:\t".send(@@colors[0])
      @guesses[index1].each_index{|index2|
        print_in_color(@guesses[index1][index2])
      }
      print "\tExact: #{@feedbacks[index1][0]}\t".send(@@colors[2])
      print "Color Correct: #{@feedbacks[index1][1]}"
    }
  end

  def print_in_color(string, spacing_char="\t")
    case string
    when @@colors[0]
      print "#{string.send(@@colors[0])}"
    when @@colors[1]
      print "#{string}"
    when @@colors[2]
      print "#{string.send(@@colors[2])}"
    when @@colors[3]
      print "#{string.send(@@colors[3])}"
    when @@colors[4]
      print "#{string.send(@@colors[4])}"
    when @@colors[5]
      print "#{string.send(@@colors[5])}"
    end
    print spacing_char
  end

  def display_instructions
    puts "\n\nMASTERMIND:\n".send(@@colors[0])
    print "Would you like to play against the computer? "
    ans = gets.chomp
    while !ans.match(/^\s*[yYnN]([eE][sS]|[oO])*\s*$/) do                                  
      print "Would you like to play against the computer?  Available options are 'y' and 'n': "
      ans = gets.chomp.downcase
    end
    ans
  end

  def get_guess
    puts "\n\n" if @i != 0
    @current_guess = get_human_responses(@pattern_length, "Guess number #{@number_of_guesses - @guesses_left + 1}.  Pick the ", "guess.", 0)
    evaluate_guess
    @guesses_left -= 1
    @guesses.push(@current_guess)
  end

  def evaluate_guess
    @is_a_winner = true
    @current_guess.each_index{|index|
      if @current_guess[index] != @pattern[index]
        @is_a_winner = false
        break
      end
    }
    if @is_a_winner
      puts "Code breakers win this time!.  "
      @pattern.each{|color|
        print_in_color(color, " ")
      }
      print "is the code.\n\n"
    else
      puts "Not Quite. Keep on guessing."
      get_guess_feedback
    end
  end

  def get_guess_feedback
    colors_added_count = Hash.new(0)
    @correct_exactly_count = 0
    @correct_color_count = 0
    @pattern.each_index{|index|
      if @pattern[index] == @current_guess[index]
        @correct_exactly_count += 1
      elsif @current_guess.any?{|item| item == @pattern[index]} 
        color_count = get_color_count_in_guess(@pattern[index])
        if (color_count >= colors_added_count[@pattern[index]] + 1)
          @correct_color_count += 1
          colors_added_count[@pattern[index]] += 1
        end
      end
    }
    raise "@correct_color_count + @correct_exactly_count cannot be higher than 4.  Something went wrong" if @correct_color_count + @correct_exactly_count > 4
    feedback = [@correct_exactly_count, @correct_color_count]
    @feedbacks.push(feedback)
  end
  
  def get_color_count_in_guess(color)
    @current_guess.reduce(0){|res, guess| 
      res += 1 if color == guess 
      res
    }
  end

  def get_pattern(pattern_chooser)
    @pattern = []
    if pattern_chooser == @@pattern_choosers[:computer]
      temp = []
      @pattern_length.times {
        temp = @@colors.sample(1)
        @pattern += temp
        temp = []
      }
    else
      puts "\nINPUTTING THE SECRET CODE:".send(@@colors[0])
      @pattern = get_human_responses(@pattern_length, "\nPick the ", "pattern.", 1)
    end
  end

  def get_human_responses(num_of_responses, msgPrefix, msgSuffix, hide)
    # puts "\n"
    i = 1
    result = []
    valid_responses = []
    @@colors.each{|color| valid_responses += [color[0]]}
    num_of_responses.times{
      # puts "i.to_s[i.to_s.length-1] #{i.to_s[i.to_s.length-1]}"
      case i.to_s[i.to_s.length-1]
      when "1"
        suffix = "st"
      when "2"
        suffix = "nd"
      when "3"
        suffix = "rd"
      else        
        suffix = "th"
      end
        print msgPrefix + "#{i}" + suffix + " color of the " + msgSuffix + "  Options are #{@@colors.to_sentence}: "
        ans = (hide == 1) ? STDIN.noecho(&:gets).chomp.strip : gets.chomp.strip
      while !@@colors.any?{|color| color.downcase == ans.downcase} && !valid_responses.any?{|color| color == ans.downcase} #todo add logic to allow shortened names?
        puts "\n" if hide == 1
        print "That is not a valid option.  Options are #{@@colors.to_sentence}: "
        ans = (hide == 1) ? STDIN.noecho(&:gets).chomp.strip : gets.chomp.strip
      end

      case ans.downcase
      when valid_responses[0]
        ans = @@colors[0]
      when valid_responses[1]
        ans = @@colors[1]
      when valid_responses[2]
        ans = @@colors[2]
      when valid_responses[3]
        ans = @@colors[3]
      when valid_responses[4]
        ans = @@colors[4]
      when valid_responses[5]
        ans = @@colors[5]
      end

      result += [ans.downcase]
      i+=1
    }
    puts "\n"
    result
  end
end

class String
  # colorization
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end

class Array
  def to_sentence
    default_words_connector     = ", "
    default_two_words_connector = " and "
    default_last_word_connector = ", and "

    case length
      when 0
        ""
      when 1
        self[0].to_s.dup
      when 2
        "#{self[0]}#{default_two_words_connector}#{self[1]}"
      else
        "#{self[0...-1].join(default_words_connector)}#{default_last_word_connector}#{self[-1]}"
    end
  end
end

mastermind_game = MastermindGame.new(10, 4)
mastermind_game.play
