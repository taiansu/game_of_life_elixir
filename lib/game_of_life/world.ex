defmodule GameOfLife.World do
  use GenServer
  @edge Application.get_env(:game_of_life, :edge)

  def start(config \\ [{4, 3}, {4, 4}, {4, 5}]) do
    GenServer.start(GameOfLife.World, config, name: :world)
  end

  def tick do
    GenServer.cast(:world, {:tick})
  end

  def init(config) do
    map = generate_map(config)
    draw(map)
    {:ok, map}
  end

  def handle_cast({:tick}, map) do
    Enum.each(map, fn cell ->
      async_query(cell, map, self)
    end)

    new_map = Enum.reduce(1..map_size(map), %{}, fn _, accu ->
      receive do
        {:next, key, status} -> Map.put(accu, key, status)
      end
    end)

    draw(new_map)
    {:noreply, new_map}
  end

  defp generate_map(config) do
    for x <- 0..@edge, y <- 0..@edge, into: %{} do
      alive = if Enum.member?(config, {x, y}), do: true, else: false
      {{x, y}, alive}
    end
  end

  defp async_query({key, _} = cell, map, pid) do
    spawn(fn ->
      send(pid, {:next, key, Cell.survive?(cell, map)})
    end)
  end

  defp to_symbol(alive) do
    if alive, do: "O", else: "-"
  end

  defp draw(map) do
    for y <- 0..@edge do
      for x <- 0..@edge do
        map[{x, y}] |> to_symbol |> String.rjust(3) |> IO.write
      end
      IO.puts ''
    end
    IO.puts ''
  end
end
