defmodule GameOfStones.Server do
  use GenServer

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
  
  # def handle_cast(request, state) do
  # def handle_cast(:some_code, current_state) do #handle_cast не возвр ответ серверу
  #   {:noreply, new_state}
  # end #суть: ничего не отправляй А (главн) изменяй 'состояние сервера'
end
