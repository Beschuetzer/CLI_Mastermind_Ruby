

class MastermindGame
  @@colors_obj = {
    black: "black",
    white: "white",
    red: "red",
    brown: "brown",
    yellow: "yellow",
    cyan: "cyan",
  }
  @@colors = %w(black white red brown yellow cyan)

  def initialize(guesses, pattern_length)
    raise "pattern_length must be 6 or lower" if pattern_length > 6
    @guesses = guesses
    @pattern_length = pattern_length  
  end

  def play
    #actually called
  end
  
  def get_pattern
    #return an array of four colors; option to have computer choose or human
    temp = []
    @pattern = []
    @pattern_length.times {
      temp = @@colors.sample(1)
      @pattern += temp
      temp = []
    }
    p @pattern
  end

  def display_game
    #prints out a 
  end

  def get_guess

  end

  def evaluate_guess
    #returns the pins to display on the board showing what is correct (either red or white)
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

mastermind_game = MastermindGame.new(12, 4)
mastermind_game.get_pattern
