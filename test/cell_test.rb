# frozen_string_literal: true

require_relative 'test_helper.rb'

require './lib/cell.rb'

class CellTest < Minitest::Test
  def test_can_create_cell
    cell = Cell.new(:alive)

    assert_instance_of Cell, cell
    assert_equal :alive, cell.status
  end

  def test_can_die
    cell = Cell.new(:alive)

    cell.die

    assert_equal :dead, cell.status
  end

  def test_can_become_alive
    cell = Cell.new(:dead)

    cell.live

    assert_equal :alive, cell.status
  end
end
