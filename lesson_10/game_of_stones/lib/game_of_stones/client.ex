
defmodule GameOfStones.Client do
  @server GameOfStones.Server

  # GameOfStones.Client.set_initial_stones(15)

  #[11]чтоб запускать через >>game_of_stones --stones 30
  def main(argv) do
    #устанав нач кол камней
    parse(argv) |> set_initial_stones()

    next_turn()
  end

  #устанав нач кол камней
  def set_initial_stones(stones_to_set) do
    case GenServer.call(@server, {:set, stones_to_set}) do
      #когда всё хорошо
      {:stones_set, player, num_stones} ->
        IO.puts("Welcome! It's player #{player} turn. #{num_stones} stones in the pile.")

      #когда всё плохо (выведем ошибку И перезапустим игру)
      {:error, reason} ->
        IO.puts("\nThere was an error: #{reason}")
        exit(:normal)
    end

    #handle_call({:set, num_stones}, _, {player, nil, :started})
  end

  #парсит ком строку >>game_of_stones --stones 30 (достаёт stones=30)
  defp parse(arguments) do
    {opts, _, _} = OptionParser.parse(arguments, switches: [stones: :integer])

    # opts |> Keyword.get(:stones, 30) #мол 30 - default кол камней (если мы прост не указали его в строке терминала)
    opts |> Keyword.get(
      :stones,
      #тут default знач камней/если не ввели в строке терминала (берёться из mix.ex из application.env /переменных окружения)
      # Application.compile_env(:game_of_stones, :default_gamestart_stones, 30) #если env храняться в mix.ex
      Application.get_env(:game_of_stones, :default_gamestart_stones, 30) #если env храняться в файле config/config.exs
      )
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
