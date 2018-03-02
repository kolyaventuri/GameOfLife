# frozen_string_literal: true

# Cell
class Cell
  attr_reader :status

  def initialize(status)
    @status = status
  end

  def die
    @status = :dead
  end

  def live
    @status = :alive
  end

  def alive?
    @status == :alive
  end
end
