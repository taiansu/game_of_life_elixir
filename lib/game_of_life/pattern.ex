defmodule GameOfLife.Pattern do
  @patterns %{
    blinker: [{8, 9}, {9, 9}, {10, 9}],
    glider: [{4, 3}, {5, 4}, {3, 5}, {4, 5}, {5, 5}],
    lwss: [{7, 7}, {10, 7}, {6, 8}, {6, 9}, {10, 9}, {6, 10}, {7, 10}, {8, 10}, {9, 10}],
    toad: [{4, 4}, {5, 4}, {6, 4}, {3, 5}, {4, 5}, {5, 5}],
    pd: [{4, 8}, {5, 8}, {7, 8}, {8, 8}, {9, 8}, {10, 8},
         {12, 8}, {13, 8}, {6, 7}, {6, 9}, {11, 7}, {11, 9}],
  }
  def get(name) do
    @patterns[name]
  end
end


