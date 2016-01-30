defmodule GameOfLife.Application do
  use Application

  def start(_, _) do
    GameOfLife.World.start

    for _ <- Stream.cycle([:ok]) do
      :timer.sleep(500)
      GameOfLife.World.tick
    end
  end
end
