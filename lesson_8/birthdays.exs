#8) Серверные процессы (long running server processes)

#===Сервер====
#будет читать msgs о birthdays И можно будет
# сохранять/вытаскивать/читать эту инфу (о birthdays)
  # будут сообщения:
  # 1)добавить birthday              2)показать все birthday
  # 3)показать чейто конкр birthday  4)удалить конкр запись
defmodule Birthdays.Server do
  #функ для запуска
  def run do
    IO.puts("Запускаем процесс Birthdays.Server...")
    if Process.whereis(:birthdays), do: Process.unregister(:birthdays) # Убить старый процесс (если он есть)
    # spawn fn -> loop(%{}) end #%{} = пустой Map (словарь / как Dict)
    pid = spawn (fn -> loop(%{}) end)
    IO.inspect(pid, label: "Создан процесс c PID")
    Process.register(pid, :birthdays) #проименовали процес (он теперь :birthday)
  end

  defp loop(current_state) do
    new_state = receive do #вечный цикл
      message -> process_message(current_state, message)
    end

    new_state |> loop()
  end

  defp process_message(current_state, { :add, name, birthday }) do
    current_state |> Map.put(name, birthday) #добавить в 'current_state' запись {name, birthday}
  end

  defp process_message(current_state, { :all, caller }) do
    caller |> send({ :response, current_state })
    current_state #обяз/чтоб продолжить loop (!)если пусто = удалим/потеряем current_state (нашу БД с birthdays)
  end

  defp process_message(current_state, { :get, caller, name }) do
    caller |> send({ :response, current_state[name] }) #вернёт запись/birthday указанного юзера
    current_state #обяз
  end

  defp process_message(current_state, { :remove, name }) do
    current_state |> Map.delete(name) #удаляет запись (по указ имени)
  end

  #ДЗ: нужна еще функ fallback (тут)
end

#====Клиент=====
defmodule Birthdays.Client do
  def all do
    do_send({ :all, self() }) #передаём {запрос, свой pid}
    get_response()
  end

  def get(name) do
    do_send({ :get, self(), name })
    get_response()
  end

  # def add(name, birthday) do
  #   do_send({ :add, name, birthday })
  # end

  def add(name, birthday), do: do_send({ :add, name, birthday })

  def remove(name), do: do_send({ :remove, name })

  defp do_send(msg), do: send(:birthdays, msg)

  defp get_response do
    receive do
      {:response, data} -> data
      _ -> :error
    after 5000 -> IO.puts "Timeout! Server does not respond("
    end

  end
end

Birthdays.Server.run

Birthdays.Client.all |> IO.inspect()

Birthdays.Client.add("Jane", "31 Aug")
Birthdays.Client.add("Bob", "5 June")
Birthdays.Client.add("Bob", "7 July") #обновили акк/инфу Боба
Birthdays.Client.all |> IO.inspect()
#%{"Bob" => "7 July", "Jane" => "31 Aug"}

Birthdays.Client.get("Bob") |> IO.inspect() #"7 July"

Birthdays.Client.add("Jim", "1 December")
Birthdays.Client.all |> IO.inspect()
#%{"Bob" => "7 July", "Jane" => "31 Aug", "Jim" => "1 December"}

Birthdays.Client.remove("Jim")
Birthdays.Client.add("Joanne", "16 December")
Birthdays.Client.all |> IO.inspect()
#%{"Bob" => "7 July", "Jane" => "31 Aug", "Joanne" => "16 December"}


#Домашнее задание:
#1)что будет если отправить серверу белеберду / чек/обработать такой исход
#2)как запустить Birthdays.Server.run не пустым А с каким-то предопределённым состоянием @default_options
#3)добавить функ "выключить сервер" (как мы сделали в scheduler.exs)

#4)Написать собств Серверный процесс/прогу калькулятор например
#который отвечает 'клиентской части' на сообщ add/sub/divide/mult/square
#и чтоб (БД) прошлых операций (и чтоб её можно было посмотреть/стереть)
#4.1) обр ошибок "чтоб не ломался когда (в кач одного из чисел) передали не число а строку"
