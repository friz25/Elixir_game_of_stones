defmodule GameOfStones.Server do
  use GenServer

  alias GameOfStones.Impl

  def init({:started, stones_num}) do #как loop() в 8уроке // изнач состояние
    # :started

    # :game_in_progress

    # :game_ended
    {:ok, {1, stones_num, :started}}
  end

  #GenServer.call(@server, :current_state)
  #state = {1, stones_num, :started}

  # def handle_call(request, from, state) do
  def handle_call(:current_state, _, {player, current_stones, _}) do
    {:reply, {player, current_stones}, {player, current_stones, :game_in_progress}}
  end

  # def handle_call(request, from, state) do
    def handle_call({:take, num_stones}, _, {player, current_stones, _}) do
      Impl.do_take({player, num_stones, current_stones})
      #должен проверить что это кол камней можно взять И вернуть схожую строку:
      #{:reply, {player, current_stones}, {player, current_stones, :game_in_progress}}
    end

  #(!)суть: ничего не отправляет НО (главн) изменяет 'состояние сервера' :
  # def handle_cast(request, state) do
  # def handle_cast(:some_code, current_state) do #handle_cast не возвр ответ серверу
  #   {:noreply, new_state}
  # end

  #когда сервер остановиться #конец_игры
  def terminate(reason, state) do
    IO.inspect(reason)
    IO.inspect(state)
    "See you soon!" |> IO.puts
  end
end


#Домашнее задание
#1)Чтоб игроки задавали/вводили свои имена
#2)Когда победитель уже есть/конец игры > спрашивать "Хотите сыграть еще раз? Да/Нет" (перезапустить игру)
#
