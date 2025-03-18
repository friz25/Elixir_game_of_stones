defmodule GameOfStones.Server do
  use GenServer,
  # restart: :permanent #перезап всегда (даже если причина выхода :normal завершение)
  # restart: :temporary #никогда не перезапускать
  restart: :transient #перезап токо! если причина выхода не :normal)

  alias GameOfStones.Impl

  def start_link(_) do
    GenServer.start_link(__MODULE__, :started, name: __MODULE__) #в init() (ниже) пошлёт :started
  end

  def init(:started) do #как loop() в 8уроке // изнач состояние
    # :started

    # :game_in_progress

    # :game_ended
    IO.puts("Booting GameOfStones server!")

    {:ok, {1, nil, :started}}
  end

  #===[11]задаём старт кол камешков (можн только на старте игры)====
  def handle_call({:set, num_stones}, _, {player, nil, :started}) do
    Impl.do_set({player, num_stones})
  end

  #GenServer.call(@server, :current_state)
  #state = {1, stones_num, :started}

  #===узнаём текущее состояние/скок осталось камушков====
  # def handle_call(request, from, state) do
  def handle_call(:current_state, _, {player, current_stones, _}) do
    {:reply, {player, current_stones}, {player, current_stones, :game_in_progress}}
  end

  #===функ: игрок пытаеться взать 1-3 камешков====
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


#[10]Домашнее задание
#1)Чтоб игроки задавали/вводили свои имена
#2)Когда победитель уже есть/конец игры > спрашивать "Хотите сыграть еще раз? Да/Нет" (перезапустить игру)

#[11]Домашнее задание
#1)Попробывать другую стратегию перезапуска
#2)что будет если отправить строку (вместо норм кол камней) в >>game_of_stones --stones 30/ чек/обработать такой исход
#или если указано слишк малое кол 1-3 - заново запроси ввод
#3)Чтоб игроки задавали/вводили свои имена в терминале >>game_of_stones --player1 Friz --player2 Vitaliy
#4)Чтоб (во время игры) к игрокам обращались по имени "теперь ходит Friz" "игрок Friz победил!!!"

