
defmodule GameOfStones.Client do
  @server GameOfStones.Server

  def play(initial_stones_num) do
    GenServer.start_link(@server, {:started, initial_stones_num}, name: @server) #start_link делает цепочку процессов

    {player, current_stones} = GenServer.call(@server, :current_state)

    IO.puts("Welcome! It's player #{player} turn. #{current_stones} stones in the pile.")

    next_turn()
  end

  defp next_turn do
    case GenServer.call(@server, {:take, ask_stones()}) do
      #:next_turn
      {:next_turn, next_player, stones_count} ->
        IO.puts("\nPlayer #{next_player} turns next. Stones: #{stones_count}")
        next_turn()

      #:error
      {:error, reason} ->
        IO.puts("\nSomething went wrong: #{reason}")
        next_turn()

      #:winner
      {:winner, winner} ->
        IO.puts("\nPlayer #{winner} wins!!! Congratulations, it was a bloody mess))")
    end
  end

  defp ask_stones do #будет спраш "скок камней хочешь взять?"
    IO.gets("\nPlease take from 1 to 3 stones:\n") |>
    String.trim() |>
    Integer.parse() |>
    stones_to_take() #чек/верифик "ввели ли мы число? а не строку"
  end

  defp stones_to_take({count, _}), do: count #отделили/вернём целую часть
  defp stones_to_take(:error), do: 0

end
