# Game Of Life Elixir

[Game of life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life), in Elixir OTP

## Run Demo
```base
$ iex -S mix

iex(1)> GameOfLife.World.loop
```

## Different Pattern
```
iex(2)> GameOfLife.World.set(:glider)
iex(3)> GameOfLife.World.loop
```

Check `lib/game_of_life/patterns` for build-in patterns,
You can also pass an array of initial pattern to `GameOfLife.World.start/1`

## Build and Run the project (Portable)

```bash
$ MIX_ENV=prod mix compile --no-debug-info
$ MIX_ENV=prod mix release
```

Copy `rel` directory to another machine, then run

```bash
$ rel/game_of_life/bin/game_of_life console

iex(1)> GameOfLife.World.loop
```
