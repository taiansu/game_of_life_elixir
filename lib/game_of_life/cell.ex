defmodule Cell do
  def survive?({coord, alive?}, map) do
    case neighbors_alive(coord, map) do
      2 -> alive?
      3 -> true
      _ -> false
    end
  end

  defp neighbors_alive(coord, map) do
    coord
    |> neighbors
    |> Enum.reduce(0, fn neighbor, accu ->
        if map[neighbor], do: accu + 1, else: accu
       end)
  end

  defp neighbors({cell_x, cell_y}) do
    for x <- -1..1, y <- -1..1, x != 0 or y != 0 do
      {cell_x + x, cell_y + y}
    end
  end
end
