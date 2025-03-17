
defmodule GameOfStones.Client do
  @server GameOfStones.Server

  def play(initial_stones_num) do
    GenServer.start_link(@server, {:started, initial_stones_num}, name: @server) #start_link делает цепочку процессов

    {player, current_stones} = GenServer.call(@server, :current_state)

    IO.puts("Welcome! It's player #{player} turn. #{current_stones} stones in the pile.")
  end
end
