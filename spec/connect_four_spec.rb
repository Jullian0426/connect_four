require 'rspec'
require_relative '../connect_four'

RSpec.describe ConnectFour do
  describe '#initialize' do
    it 'creates a 6x7 board' do
      game = ConnectFour.new
      expect(game.board.size).to eq(6)
      expect(game.board.all? { |row| row.size == 7 }).to be true
    end

    it 'initializes the board with empty spaces' do
      game = ConnectFour.new
      expect(game.board.flatten.all? { |cell| cell == ' ' }).to be true
    end
  end

  describe '#display_board' do
    it 'displays the board correctly' do
      game = ConnectFour.new
      expect { game.display_board }.to output(
        "  |   |   |   |   |   |  \n" * 6 +
        "1   2   3   4   5   6   7\n"
      ).to_stdout
    end
  end

  describe '#make_move' do
    it 'allows player 1 to make a move' do
      game = ConnectFour.new
      expect(game.make_move(1)).to be true
      expect(game.board[5][0]).to eq('X')
    end

    it 'switches to player 2 after player 1 makes a move' do
      game = ConnectFour.new
      game.make_move(1)
      expect(game.make_move(1)).to be true
      expect(game.board[4][0]).to eq('O')
    end

    it 'does not allow a move in a full column' do
      game = ConnectFour.new
      6.times { game.make_move(1) }
      expect(game.make_move(1)).to be false
    end
  end

  describe '#valid_move?' do
    it 'returns true for a valid move' do
      game = ConnectFour.new
      expect(game.send(:valid_move?, 1)).to be true
    end

    it 'returns false for a column that is out of bounds' do
      game = ConnectFour.new
      expect(game.send(:valid_move?, 0)).to be false
      expect(game.send(:valid_move?, 8)).to be false
    end

    it 'returns false for a full column' do
      game = ConnectFour.new
      6.times { game.make_move(1) }
      expect(game.send(:valid_move?, 1)).to be false
    end
  end

  describe '#check_winner' do
    it 'detects a horizontal win' do
      game = ConnectFour.new
      game.make_move(1)
      game.make_move(1)
      game.make_move(2)
      game.make_move(2)
      game.make_move(3)
      game.make_move(3)
      game.make_move(4)
      expect(game.board[5][0]).to eq('X')
      expect(game.board[5][1]).to eq('X')
      expect(game.board[5][2]).to eq('X')
      expect(game.board[5][3]).to eq('X')
      expect(game.send(:check_winner, 5, 3)).to be true
    end

    it 'detects a vertical win' do
      game = ConnectFour.new
      4.times { game.make_move(1) }
      expect(game.board[5][0]).to eq('X')
      expect(game.board[4][0]).to eq('X')
      expect(game.board[3][0]).to eq('X')
      expect(game.board[2][0]).to eq('X')
      expect(game.send(:check_winner, 2, 0)).to be true
    end

    it 'detects a diagonal win (bottom left to top right)' do
      game = ConnectFour.new
      game.make_move(1)
      game.make_move(2)
      game.make_move(2)
      game.make_move(3)
      game.make_move(4)
      game.make_move(3)
      game.make_move(3)
      game.make_move(4)
      game.make_move(4)
      game.make_move(4)
      game.make_move(5)
      game.make_move(4)
      expect(game.send(:check_winner, 2, 3)).to be true
    end

    it 'detects a diagonal win (bottom right to top left)' do
      game = ConnectFour.new
      game.make_move(4)
      game.make_move(3)
      game.make_move(3)
      game.make_move(2)
      game.make_move(2)
      game.make_move(1)
      game.make_move(2)
      game.make_move(1)
      game.make_move(1)
      game.make_move(1)
      expect(game.send(:check_winner, 2, 1)).to be true
    end
  end
end