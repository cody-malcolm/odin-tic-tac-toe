# frozen_string_literal: true

# One of the (human) Players in the Game
class Player
  attr_reader :name, :symbol

  def initialize(player_number)
    @symbols = %i[O X $ # % & @]
    init_name(player_number)
    init_symbol
  end

  private

  def init_name(number)
    puts "Hello player #{number}, what is your name?"
    @name = gets.chomp
  end

  # TODO: prevent duplicate symbol selection
  def init_symbol
    print "Thank you, #{@name}. What symbol would you like to use? "
    p "(#{@symbols.join(', ')})"
    @symbol = gets.chomp
  end
end

# Handles functionality of a single Game
class Game
  def initialize
    @players = []
  end

  def setup
    2.times { |i| setup_player(i + 1) }
  end

  def start
    puts 'Game is started. Players are: '
    puts @players[0].name
    puts @players[0].symbol
    puts @players[1].name
    puts @players[1].symbol
    false
  end

  private

  def setup_player(player_number)
    @players.push(Player.new(player_number))
  end
end

# Run the program
play_again = true

while play_again
  game = Game.new
  game.setup
  play_again = game.start
end

puts 'Thank you for playing Tic-Tac-Toe!'
