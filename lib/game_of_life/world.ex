defmodule GameOfLife.World do
  use GenServer
  @edge Application.get_env(:game_of_life, :edge)
  @init Application.get_env(:game_of_life, :init)

  def start(init \\ @init) do
    GenServer.start(GameOfLife.World, get_cell_list(init), name: :world)
  end

  def tick do
    GenServer.cast(:world, {:tick})
  end

  def set(arg) do
    GenServer.cast(:world, {:set, get_cell_list(arg)})
  end

  def loop(rate \\ 500) do
    for _ <- Stream.cycle([:ok]) do
      :timer.sleep(rate)
      tick
    end
  end

  defp get_cell_list(arg) when is_list(arg), do: arg
  defp get_cell_list(arg) when is_atom(arg), do: GameOfLife.Pattern.get(arg)

  def init(cell_list) do
    {:ok, set_map(cell_list)}
  end

  def handle_cast({:tick}, map) do

    Enum.each(map, fn cell ->
      async_query(cell, map, self)
    end)

    Enum.reduce(map, %{}, fn _, accu ->
      receive do
        {:next, key, status} -> Map.put(accu, key, status)
      end
    end)
    |> draw
    |> fn (new_map) -> {:noreply, new_map} end.()
  end

  def handle_cast({:set, cell_list}, map) do
    {:noreply, set_map(cell_list)}
  end

  defp set_map(cell_list) do
    cell_list |> generate_map |> draw
  end

  defp generate_map(cell_list) do
    for x <- 0..@edge, y <- 0..@edge, into: %{} do
      alive = if Enum.member?(cell_list, {x, y}), do: true, else: false
      {{x, y}, alive}
    end
  end

  defp draw(map) do
    for y <- 0..@edge do
      for x <- 0..@edge do
        map[{x, y}] |> to_symbol |> String.rjust(3) |> IO.write
      end
      IO.puts ''
    end
    IO.puts ''
    map
  end

  defp to_symbol(alive) do
    if alive, do: "O", else: "-"
  end

  defp async_query({key, _} = cell, map, pid) do
    spawn(fn ->
      send(pid, {:next, key, Cell.survive?(cell, map)})
    end)
  end
end
