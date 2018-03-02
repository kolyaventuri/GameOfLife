require './lib/game'
require 'io/console'
def winsize
  IO.console.winsize
end

rows, cols = winsize

game = Game.new(cols - 1, rows - 5)

1000.times do |n|
  system 'clear'
  puts "Generation #{n} of 1000\n\n"
  puts game.output_grid
  game.next_generation
  sleep 0.25
end
