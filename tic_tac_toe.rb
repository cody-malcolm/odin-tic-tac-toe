# frozen_string_literal: true

# One of the (human) Players in the Game
class Player
  attr_reader :name, :symbol

  def initialize(player_number)
    @symbols = %i[O X $ # % & @]
    init_name(player_number)
    init_symbol
  end

  def move_selection
    puts "#{@name}, please select a square for your next move."
    gets.chomp
  end

  private

  def init_name(number)
    puts "Hello player #{number}, what is your name?"
    @name = gets.chomp
  end

  # TODO: prevent duplicate symbol selection and incorrect symbol selection
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
    @board = '123456789'
  end

  def setup
    2.times { |i| setup_player(i + 1) }
  end

  def start
    puts ''
    puts 'Game is started.'
    puts ''
    9.times { |i| handle_turn(@players[i % 2]) }
    display_result
    new_game?
  end

  private

  def new_game?
    puts 'Would you like to play a new game? (y/n)'
    answer = gets.chomp
    until %i[y n].include?(answer.to_sym)
      puts 'That was not a valid selection!'
      puts 'Would you like to play a new game? (y/n)'
      answer = gets.chomp
    end

    answer == 'y'
  end

  def display_board
    puts ''
    puts "    #{@board.slice(0)} | #{@board.slice(1)} | #{@board.slice(2)}"
    puts '   -----------'
    puts "    #{@board.slice(3)} | #{@board.slice(4)} | #{@board.slice(5)}"
    puts '   -----------'
    puts "    #{@board.slice(6)} | #{@board.slice(7)} | #{@board.slice(8)}"
    puts ''
  end

  def display_result
    puts 'The game is over'
    puts ''
  end

  def valid_selection?(selection)
    single_number = '123456789'.chars.include?(selection)
    '123456789'.include?(@board.slice(selection.to_i - 1)) if single_number
  end

  def apply_selection(symbol, selection)
    temp = @board.split('')
    temp[selection - 1] = symbol
    @board = temp.join
  end

  def handle_turn(player)
    display_board

    selection = player.move_selection

    until valid_selection?(selection)
      puts 'That was not a valid selection!'
      display_board
      selection = player.move_selection
    end

    apply_selection(player.symbol, selection.to_i)
  end

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
