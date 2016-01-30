defmodule GameOfLife.Application do
  use Application

  def start(_, _) do
    GameOfLife.World.start
  end
end
