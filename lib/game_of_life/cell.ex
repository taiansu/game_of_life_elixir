defmodule Cell do
  @edge Application.get_env(:game_of_life, :edge)

  def survive?({_, alive?} = cell, map) do
    case n = neighbors_alive(cell, map) do
      2 -> alive?
      3 -> true
      _ when n > -1 and n < @edge -> false
    end
  end

  defp neighbors_alive(cell, map) do
    cell
    |> neighbors
    |> Enum.reduce(0, fn neighbor, accu ->
        if map[neighbor], do: accu + 1, else: accu
       end)
  end

  defp neighbors({{cell_x, cell_y}, _}) do
    for x <- -1..1, y <- -1..1, x != 0 or y != 0 do
      {cell_x + x, cell_y + y}
    end
  end
end
