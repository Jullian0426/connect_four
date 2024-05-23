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
    check_horizontal(row) || check_vertical(column) || check_diagonals(row, column)
  end

  def check_horizontal(row)
    @board[row].each_cons(4).any? { |sequence| sequence.uniq.size == 1 && sequence.first != ' ' }
  end

  def check_vertical(column)
    @board.map { |row| row[column] }.each_cons(4).any? { |sequence| sequence.uniq.size == 1 && sequence.first != ' ' }
  end

  def check_diagonals(row, column)
    check_diagonal1(row, column) || check_diagonal2(row, column)
  end

  def check_diagonal1(row, column)
    sequence = []
    (-3..3).each do |i|
      r, c = row + i, column + i
      sequence << @board[r][c] if r.between?(0, 5) && c.between?(0, 6)
    end
    sequence.each_cons(4).any? { |seq| seq.uniq.size == 1 && seq.first != ' ' }
  end

  def check_diagonal2(row, column)
    sequence = []
    (-3..3).each do |i|
      r, c = row + i, column - i
      sequence << @board[r][c] if r.between?(0, 5) && c.between?(0, 6)
    end
    sequence.each_cons(4).any? { |seq| seq.uniq.size == 1 && seq.first != ' ' }
  end
end

if __FILE__ == $PROGRAM_NAME
  game = ConnectFour.new
  game.play
end