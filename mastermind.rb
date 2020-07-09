require 'io/console'


class MastermindGame
  @@colors_obj = {
    black: "black",
    white: "white",
    red: "red",
    brown: "brown",
    yellow: "yellow",
    cyan: "cyan",
  }
  @@pattern_choosers = {
    computer: 0,
    human: 1,
  }
  @@colors = %w(black white red brown yellow cyan)

  def initialize(number_of_guesses, pattern_length)
    raise "pattern_length must be 6 or lower" if pattern_length > 6
    @number_of_guesses = number_of_guesses
    @pattern_length = pattern_length  
    @guesses = []
    @guesses_left = number_of_guesses
  end

  def play
    #actually called
    display_instructions.include?('y') ? get_pattern(0) : get_pattern(1)
    while @guesses_left > 0
      get_guess
    end
  end

  def display_instructions
    print "MASTERMIND\nWould you like to play against the computer? "
    ans = gets.chomp
    while !ans.match(/^\s*[yYnN]([eE][sS]|[oO])*\s*$/) do                                  
      print "Would you like to play against the computer?  Available options are 'y' and 'n': "
      ans = gets.chomp.downcase
    end
    ans
  end

  def display_game
    #prints out a 
  end

  def get_guess
    @current_guess = get_human_responses(@pattern_length, "Guess number #{@number_of_guesses - @guesses_left + 1}.  Pick the ", "guess.")
    evaluate_guess
    @guesses_left -= 1
    @guesses.push(@current_guess)
    puts "@guesses: #{@guesses}, guesses_left: #{@guesses_left}, and curent guess: #{@current_guess}"
  end

  def evaluate_guess
    #returns the pins to display on the board showing what is correct (either red or white)
  end

  def get_pattern(pattern_chooser)
    #return an array of four colors; option to have computer choose or human
    @pattern = []
    if pattern_chooser == @@pattern_choosers[:computer]
      temp = []
      @pattern_length.times {
        temp = @@colors.sample(1)
        @pattern += temp
        temp = []
      }
    else
      @pattern = get_human_responses(@pattern_length, "Pick the ", "pattern.")
    end
  end

  def get_human_responses(num_of_responses, msgPrefix, msgSuffix)
    i = 1
    result = []
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
        print "\n" + msgPrefix + "#{i}" + suffix + " color of the " + msgSuffix + "  Options are #{@@colors.to_sentence}: "
      ans = STDIN.noecho(&:gets).chomp.strip
      while !@@colors.any?{|color| color.downcase == ans.downcase} #todo add logic to allow shortened names?
        print "\nThat is not a valid option.  Options are #{@@colors.to_sentence}: "
        ans = STDIN.noecho(&:gets).chomp.strip
      end
      print "\nColor accepted.  "
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

mastermind_game = MastermindGame.new(12, 4)
mastermind_game.play
