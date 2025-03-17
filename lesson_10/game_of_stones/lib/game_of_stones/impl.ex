# Implimentation (сервисы)
defmodule GameOfStones.Impl do
  # должен проверить что это кол камней можно взять И вернуть схожую строку:
  # {:reply, {player, current_stones}, {player, current_stones, :game_in_progress}}

  # обрабатывем возможные ошибки
  def do_take({player, num_stones, current_stones})
      when not is_integer(num_stones) or
             num_stones < 1 or
             num_stones > 3 or
             num_stones > current_stones do
    # когда всё плохо
    {
      :reply,
      {
        :error,
        "You can take from 1 to 3 stones, and it should exceed the total count of stones!"
      },
      # вернуть новое состояние сервера/current_stones
      {player, current_stones, :game_in_progress}
    }
  end

  #когда (ктото из игроков) взял последний камень #конец_игры
  def do_take({player, num_stones, current_stones})
  when num_stones == current_stones do
    {
      :stop,
      :normal,
      {:winner, next_player(player)},
      {nil, 0, :game_ended} # новое состояние сервера/current_stones
    }
  end


  #когда всё хорошо (игрок ввёл норм кол-во камней)
  def do_take({player, num_stones, current_stones}) do
    next_p = next_player(player) #функция которая узнаёт чей след ход

    new_stones = current_stones - num_stones

    {
      :reply,
      {:next_turn, next_p, new_stones}, # ответ клиенту
      {next_p, new_stones, :game_in_progress} # новое состояние сервера/current_stones
    }
  end

  # так как у нас всего 2 игрока
  defp next_player(1), do: 2 #после 1го ходит 2й
  defp next_player(2), do: 1 #после 2го ходит (снова) 1й
end
