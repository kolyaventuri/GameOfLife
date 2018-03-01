require './lib/game'

game = Game.new(40, 40)

1000.times do |n|
  system 'clear'
  puts "Generation #{n} of 1000\n\n"
  puts game.output_grid
  game.next_generation
  sleep 0.25
end