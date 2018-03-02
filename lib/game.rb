# frozen_string_literal: true

require 'pry'

# Define grid
class Game
  attr_accessor :grid

  def initialize(width, height)
    @grid = Array.new(height) do
      Array.new(width) do
        rand(2)
      end
    end
  end

  def neighbors(cell_x, cell_y)
    get_neighbors(cell_x, cell_y).count(1)
  end

  def get_neighbors(cell_x, cell_y)
    dirs = [-1, 0, 1]
    grid = []

    dirs.each do |dir_y|
      dirs.each do |dir_x|
        grid << get_cell(cell_x, cell_y, dir_x, dir_y)
      end
    end

    grid.reject { |cell| cell == 'x' }
  end

  def get_cell(look_from_x, look_from_y, dir_x, dir_y)
    x_coord = look_from_x + dir_x
    y_coord = look_from_y + dir_y

    return 0 unless within_grid?(x_coord, y_coord)
    return 'x' if x_coord == look_from_x && y_coord == look_from_y

    @grid[y_coord][x_coord]
  end

  def within_grid?(x, y)
    return false if y.negative? || y >= @grid.length
    return false if x.negative? || x >= @grid[0].length
    true
  end

  def will_live?(x, y)
    neighbors(x, y) == 2 || neighbors(x, y) == 3
  end

  def reproduces?(x, y)
    neighbors(x, y) == 3
  end

  def next_generation
    @grid = @grid.map.with_index do |row, y|
      row.map.with_index do |cell, x|
        cell = 0 unless will_live?(x, y)
        cell = 1 if reproduces?(x, y)
        cell
      end
    end
  end

  def output_grid
    @grid.map do |row|
      row.map do |cell|
        if cell == 1
          '*'
        else
          ' '
        end
      end.join
    end.join("\n")
  end
end
