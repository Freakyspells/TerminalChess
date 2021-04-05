# frozen_string_literal: true
require_relative 'classes/board'

def clear
    puts "\e[H\e[2J"
end

def print_start
    puts 'Starting a new game of chess!'
    puts "To move select a piece by it's position."
    puts 'Then enter where you would like to move it.'
    puts 'Type forfeit if you have lost or give up.'
    puts 'Have fun!'
end

def get_move(player)
    print "#{player} select a piece to move :"
    position1 = gets.chomp
    if position1 == 'forfeit'
        return false
    end
    print "Where would you like to move?: "
    position2 = gets.chomp
    
    return position2 == 'forfeit' ? false : position1, position2

end

def turn(game, player)
    position1, position2 = get_move(player)
    if position1 && position2
        game.move_piece(position1, position2)
        clear
        game.print_board
        return true
    else
        return false
    end
end

def get_player(player_number)
    print "Player#{player_number} enter your name: "
    player = gets.chomp
    if player == ''
        return "Player#{player_number}"
    else
        return player
    end
end

# starts game & prints welcome message
game1 = Board.new
player1 = get_player(1)
player2 = get_player(2)
clear
print_start
game1.print_board

# Sets flags for end of game condition.
forfeit = false
checkmate = false

while forfeit == false && checkmate == false
    if turn(game1, player1) == false
        winner = player2
        forfeit = true
    elsif turn(game1, player2) == false
        winner = player1
        forfeit = true
    end
end

puts "Congratulations #{winner} you won!!"
