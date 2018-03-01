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
    start_y = cell_y - 1
    end_y = cell_y + 1

    start_x = cell_x - 1
    end_x = cell_x + 1

    num_neighbors = 0

    for y in (start_y..end_y) do
      next if y < 0 || y >= @grid.length
      for x in (start_x..end_x) do
        next if x < 0
        next if y == cell_y && x == cell_x
        num_neighbors += 1 if @grid[y][x] == 1
      end
    end

    num_neighbors
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
