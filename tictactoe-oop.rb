# encoding: UTF-8
require 'pry'

class Engine
	attr_accessor :state, :human, :computer

	def initialize		
		@human = Human.new
		@computer = Computer.new
	end

	def game_main_loop
		system 'clear'
		display_welcome_message
		loop do
			@state = State.new
			first_move?
			while !state.game_over
				state.human_turn ? move = human.move(state) : move = computer.move(state)
				state.update_state(move)
				state.display
				# puts state.game_over
				# puts state.human_won
				# puts state.computer_won
				# puts state.grid_full
				# p state.lines
				# p state.squares
				# binding.pry	
			end 
			display_game_over_message
			break unless play_again?
		end 
	end

	private

	def display_welcome_message
		puts "Welcome to Tic-Tac-Toe!"
	end

	def first_move?
		puts "\nDo you want to make the first move? (y/n)"
		if gets.chomp.downcase == "y" then state.human_turn = true end
	end

	def display_game_over_message
		if !state.computer_won && !state.human_won
			puts "\nIt is a tie!"
		elsif state.human_won
			puts "\nCongratulations! You win!"
		else
			puts "\nSorry! You lose!"
		end
	end

	def play_again?
		puts "\nDo you want to play again? (y/n)"
		gets.chomp.downcase == "y"
	end
end

class State
	attr_accessor :squares, :human_turn, :grid_full, :human_won, :computer_won, :game_over

	def initialize
		grid = Grid.new
		@squares = grid.squares
		@human_turn = false
		@grid_full = false
		@human_won = false
		@computer_won = false
		@game_over = false
	end

	def update_state(move)		
		self.squares[move[0]] = move[1]		
		self.human_turn = move[1] == 'O'
		analizer = Analizer.new(self)
		self.grid_full = analizer.grid_full?
		self.human_won = analizer.human_won?
		self.computer_won = analizer.computer_won?
		self.game_over = analizer.game_over?
	end

	def lines
		[
			[squares[:'1'], squares[:'2'], squares[:'3']],
			[squares[:'4'], squares[:'5'], squares[:'6']],
			[squares[:'7'], squares[:'8'], squares[:'9']],
			[squares[:'1'], squares[:'4'], squares[:'7']],
			[squares[:'2'], squares[:'5'], squares[:'8']],
			[squares[:'3'], squares[:'6'], squares[:'9']],
			[squares[:'1'], squares[:'5'], squares[:'9']],
			[squares[:'3'], squares[:'5'], squares[:'7']]
		]
	end

	def display
		puts "
      |     |
   #{squares[:'7']}  |  #{squares[:'8']}  |  #{squares[:'9']}
 _____|_____|_____
      |     |
   #{squares[:'4']}  |  #{squares[:'5']}  |  #{squares[:'6']}
 _____|_____|_____
      |     |
   #{squares[:'1']}  |  #{squares[:'2']}  |  #{squares[:'3']}
      |     |"
	end
end

class Analizer
	attr_reader :state

	def initialize(state)
		@state = state
	end

	def move_legal?(move)
		state.squares[move[0]] == ' '
	end

	def best_move
		state.squares.select { |k,v| v == ' ' }.to_a.sample[0]
	end

	def grid_full?
		!state.squares.has_value?(' ')
	end

	def human_won?
		state.lines.include?(['X','X','X'])
	end

	def computer_won?
		state.lines.include?(['O','O','O'])
	end

	def game_over?
		grid_full? || human_won? || computer_won? 
	end

	private

end

class Human	 
	def move(state)
		begin
			puts "\nWhat is your move?"
			input = gets.chomp
		end until (1..9).include?(input.to_i) && Analizer.new(state).move_legal?([input.to_sym, 'X'])
		[input.to_sym, 'X']
	end
end

class Computer
	def move(state)
		best_square = Analizer.new(state).best_move		
		[best_square, 'O']
	end
end

class Grid
	attr_reader :squares

	def initialize
		@squares = {'1':' ', '2':' ', '3':' ', '4':' ', '5':' ', '6':' ', '7':' ', '8':' ', '9':' '}
	end

	def display
		puts "
      |     |
   #{squares[:'7']}  |  #{squares[:'8']}  |  #{squares[:'9']}
 _____|_____|_____
      |     |
   #{squares[:'4']}  |  #{squares[:'5']}  |  #{squares[:'6']}
 _____|_____|_____
      |     |
   #{squares[:'1']}  |  #{squares[:'2']}  |  #{squares[:'3']}
      |     |"
	end

	def instructions
		puts "
      |     |
   7  |  8  |  9 
 _____|_____|_____
      |     |
   4  |  5  |  6 
 _____|_____|_____
      |     |
   1  |  2  |  3
      |     |"
	end
end

e = Engine.new.game_main_loop