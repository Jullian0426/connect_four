class ConnectFour
  attr_reader :board

  def initialize
    @board = Array.new(6) { Array.new(7, ' ') }
    @current_player = 'X'
  end

  def display_board
    @board.each do |row|
      puts row.join(' | ')
    end
    puts (1..7).to_a.join('   ')
  end

  def make_move(column)
    column -= 1
    (5).downto(0) do |row|
      if @board[row][column] == ' '
        @board[row][column] = @current_player
        if check_winner(row, column)
          display_board
          puts "Player #{@current_player} wins!"
          exit
        else
          switch_player
        end
        return true
      end
    end
    false
  end

  def play
    loop do
      display_board
      puts "Player #{@current_player}, choose a column (1-7):"
      column = gets.chomp.to_i

      if valid_move?(column)
        make_move(column)
      else
        puts "Invalid move. Please choose a column between 1 and 7 that is not full."
      end
    end
  end

  private

  def switch_player
    @current_player = @current_player == 'X' ? 'O' : 'X'
  end

  def valid_move?(column)
    column.between?(1, 7) && @board[0][column - 1] == ' '
  end

  def check_winner(row, column)
    check_direction(row, column, 1, 0) ||  # Horizontal
    check_direction(row, column, 0, 1) ||  # Vertical
    check_direction(row, column, 1, 1) ||  # Diagonal /
    check_direction(row, column, 1, -1)    # Diagonal \
  end

  def check_direction(row, column, row_dir, col_dir)
    total = 1 + count_consecutive(row, column, row_dir, col_dir) + count_consecutive(row, column, -row_dir, -col_dir)
    total >= 4
  end

  def count_consecutive(row, column, row_dir, col_dir)
    count = 0
    current_row, current_col = row + row_dir, column + col_dir
    while current_row.between?(0, 5) && current_col.between?(0, 6) && @board[current_row][current_col] == @current_player
      count += 1
      current_row += row_dir
      current_col += col_dir
    end
    count
  end
end

if __FILE__ == $PROGRAM_NAME
  game = ConnectFour.new
  game.play
end