require_relative 'test_helper.rb'

require './lib/game.rb'

class GameTest < Minitest::Test
  def test_generates_grid
    game = Game.new(4, 5)

    assert_instance_of Array, game.grid
    assert_equal 5, game.grid.length

    game.grid.each do |row|
      assert_instance_of Array, row
      assert_equal 4, row.length
    end
  end

  def test_it_populates
    game = Game.new(4, 5)
    possible_values = [0, 1]

    game.grid.each do |row|
      row.each do |cell|
        assert_includes possible_values, cell
      end
    end
  end

  def test_can_count_neighbors
    grid = [
      [1, 0, 0, 1],
      [0, 1, 1, 0],
      [1, 1, 0, 0],
      [1, 0, 1, 0]
    ]

    game = Game.new(0, 0)
    game.grid = grid

    assert_equal 5, game.neighbors(1, 2)
    assert_equal 2, game.neighbors(3, 2)
  end

  def test_they_live_or_die
    grid = [
      [1, 0, 0, 1],
      [0, 1, 1, 0],
      [1, 1, 0, 0],
      [1, 0, 1, 0]
    ]

    game = Game.new(0, 0)
    game.grid = grid

    refute game.will_live?(1, 2)
    assert game.will_live?(0, 3)
    refute game.will_live?(3, 3)
  end

  def test_they_reproduce
    grid = [
      [1, 0, 0, 1],
      [0, 1, 1, 0],
      [1, 1, 0, 0],
      [1, 0, 1, 0]
    ]

    game = Game.new(0, 0)
    game.grid = grid

    assert game.reproduces?(2, 0)
    refute game.reproduces?(0, 1)
  end

  def test_manipulates_cells
    grid = [
      [1, 0, 0, 1],
      [0, 1, 1, 0],
      [1, 1, 0, 0],
      [1, 0, 1, 0]
    ]

    game = Game.new(0, 0)
    game.grid = grid

    game.next_generation

    expected = [
      [0, 1, 1, 0],
      [0, 0, 1, 0],
      [1, 0, 0, 0],
      [1, 0, 0, 0]
    ]

    assert_equal expected, game.grid

    game.next_generation

    expected = [
      [0, 1, 1, 0],
      [0, 0, 1, 0],
      [0, 1, 0, 0],
      [0, 0, 0, 0]
    ]

    assert_equal expected, game.grid
  end

  def test_outputs_cells
    grid = [
      [1, 0, 0, 1],
      [0, 1, 1, 0],
      [1, 1, 0, 0],
      [1, 0, 1, 0]
    ]

    game = Game.new(0, 0)
    game.grid = grid

    expected = File.read('./data/expected.txt')

    assert_equal expected, game.output_grid
  end
end
