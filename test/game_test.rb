# frozen_string_literal: true

require_relative 'test_helper.rb'

require './lib/game.rb'
require './lib/cell.rb'

class GameTest < Minitest::Test
  def setup
    @live = Cell.new(:alive)
    @dead = Cell.new(:dead)
  end

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

    game.grid.each do |row|
      row.each do |cell|
        assert_instance_of Cell, cell
      end
    end
  end

  def test_can_get_cell_relative
    grid = [
      [@live, @dead, @dead, @live],
      [@dead, @live, @live, @dead],
      [@live, @live, @dead, @dead],
      [@live, @dead, @live, @dead]
    ]

    game = Game.new(0, 0)
    game.grid = grid

    assert_equal :dead, game.get_cell(0, 0, -1, -1).status
    assert_equal :alive, game.get_cell(1, 1, -1, 1).status
    assert_equal :dead, game.get_cell(1, 1, -1, 0).status
    assert_equal :dead, game.get_cell(2, 3, 1, 1).status

    assert_equal :alive, game.get_cell(1, 1, 1, 0).status
  end

  def test_can_get_within_grid
    game = Game.new(5, 5)

    assert game.within_grid?(2, 2)
    refute game.within_grid?(-1, 2)
    refute game.within_grid?(2, 6)
  end

  def test_can_get_neighbors
    grid = [
      [@live, @dead, @dead, @live],
      [@dead, @live, @live, @dead],
      [@live, @live, @dead, @dead],
      [@live, @dead, @live, @dead]
    ]

    game = Game.new(0, 0)
    game.grid = grid

    expected = [
      [@live, @dead, @dead],
      [@dead, @live],
      [@live, @live, @dead]
    ].flatten

    game.get_neighbors(1, 1).each_with_index do |cell, index|
      assert cell.status == expected[index].status
    end

    expected = [
      [@dead, @dead, @dead],
      [@live, @dead],
      [@dead, @dead, @dead]
    ].flatten

    game.get_neighbors(3, 3).each_with_index do |cell, index|
      assert cell.status == expected[index].status
    end
  end

  def test_can_count_neighbors
    grid = [
      [@live, @dead, @dead, @live],
      [@dead, @live, @live, @dead],
      [@live, @live, @dead, @dead],
      [@live, @dead, @live, @dead]
    ]

    game = Game.new(0, 0)
    game.grid = grid

    assert_equal 5, game.neighbors(1, 2)
    assert_equal 2, game.neighbors(3, 2)
  end

  def test_they_live_or_die
    grid = [
      [@live, @dead, @dead, @live],
      [@dead, @live, @live, @dead],
      [@live, @live, @dead, @dead],
      [@live, @dead, @live, @dead]
    ]

    game = Game.new(0, 0)
    game.grid = grid

    refute game.will_live?(1, 2)
    assert game.will_live?(0, 3)
    refute game.will_live?(3, 3)
  end

  def test_they_reproduce
    grid = [
      [@live, @dead, @dead, @live],
      [@dead, @live, @live, @dead],
      [@live, @live, @dead, @dead],
      [@live, @dead, @live, @dead]
    ]

    game = Game.new(0, 0)
    game.grid = grid

    assert game.reproduces?(2, 0)
    refute game.reproduces?(0, 1)
  end

  def test_manipulates_cells
    grid = [
      [@live, @dead, @dead, @live],
      [@dead, @live, @live, @dead],
      [@live, @live, @dead, @dead],
      [@live, @dead, @live, @dead]
    ]

    game = Game.new(0, 0)
    game.grid = grid

    game.next_generation

    expected = [
      [@dead, @live, @live, @dead],
      [@dead, @dead, @live, @dead],
      [@live, @dead, @dead, @dead],
      [@live, @dead, @dead, @dead]
    ].flatten

    game.grid.flatten.each_with_index do |cell, index|
      assert cell.status == expected[index].status
    end

    game.next_generation

    expected = [
      [@dead, @live, @live, @dead],
      [@dead, @dead, @live, @dead],
      [@dead, @live, @dead, @dead],
      [@dead, @dead, @dead, @dead]
    ].flatten

    game.grid.flatten.each_with_index do |cell, index|
      assert cell.status == expected[index].status
    end
  end

  def test_outputs_cells
    grid = [
      [@live, @dead, @dead, @live],
      [@dead, @live, @live, @dead],
      [@live, @live, @dead, @dead],
      [@live, @dead, @live, @dead]
    ]

    game = Game.new(0, 0)
    game.grid = grid

    expected = File.read('./data/expected.txt')

    assert_equal expected, game.output_grid
  end
end
