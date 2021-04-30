# frozen_string_literal: true

# One of the (human) Players in the Game
class Player
  attr_reader :name, :symbol

  # symbol is nil for p1 and the symbol p1 selected for p2
  def initialize(player_number, symbol)
    @symbols = %i[O X $ # % & @].reject { |sym| sym == symbol }
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

  def init_symbol
    print "Thank you, #{@name}. What symbol would you like to use? "
    p "(#{@symbols.join(', ')})"
    @symbol = gets.chomp.to_sym

    until @symbols.include?(@symbol)
      puts "That symbol wasn't valid."
      print 'What symbol would you like to use? '
      p "(#{@symbols.join(', ')})"
      @symbol = gets.chomp.to_sym
    end
  end
end

# Handles functionality of a single Game
class Game
  def initialize
    @players = []
    @board = '123456789'
  end

  def setup
    # p1 passes nil for symbol, p2 passes p1's selection as symbol
    2.times { |i| setup_player(i + 1, i == 1 ? @players[0].symbol : nil) }
    @players[0], @players[1] = @players[1], @players[0] if rand < 0.5
  end

  def start
    puts ''
    puts 'Game is started.'

    play_game

    display_result
    new_game?
  end

  private

  def play_game
    finished = false
    i = 0

    until finished
      finished = handle_turn(@players[i % 2])
      i += 1
    end
  end

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
    display_board
    if winner_found?
      winning_player = player_won?(@players[0]) ? @players[0] : @players[1]
      puts "#{winning_player.name} won the game!"
    else
      puts 'The game was a draw!'
    end
  end

  def player_won?(player)
    symbol = player.symbol
    winning_configs = [
      [0, 1, 2], [0, 3, 6],
      [3, 4, 5], [1, 4, 7],
      [6, 7, 8], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ]

    winning_configs.any? { |config| config.all? { |i| @board[i].to_sym == symbol } }
  end

  def valid_selection?(selection)
    # need .chars to make sure for eg. '12' doesn't match
    single_number = '123456789'.chars.include?(selection)
    '123456789'.include?(@board.slice(selection.to_i - 1)) if single_number
  end

  def apply_selection(symbol, selection)
    temp = @board.split('')
    temp[selection - 1] = symbol
    @board = temp.join

    game_over?
  end

  def game_over?
    winner_found? || board_full?
  end

  def winner_found?
    player_won?(@players[0]) || player_won?(@players[1])
  end

  def board_full?
    @board.chars.none?(/\d/)
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

  def setup_player(player_number, symbol)
    @players.push(Player.new(player_number, symbol))
  end
end

# Run the program
play_again = true

while play_again
  game = Game.new
  game.setup
  play_again = game.start
end

puts ''
puts 'Thank you for playing Tic-Tac-Toe!'
