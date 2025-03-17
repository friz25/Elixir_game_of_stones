#7) Процессы, мониторы, spawn, spawn_link и практика
# оч легко наплодить процессов / процессы живут отдельно (у кажд своя память)
# они могут общаться между собой (сообщениями (оч легкими/1kb))
# Процессы управляються Планировщиками/Schedulers (авто создаст 1 шт для каждого ЦП)
# defmodule Demo do
#   # def do_this do
#   def do_this(caller) do #[4]
#     :timer.sleep 1000

#     result = 42
#     # result |> IO.puts
#     # result
#     send caller, { :ok, result } #[4] отправляем ответ/msg
#   end

#   # def do_that do
#   def do_that(caller) do #[4]
#     :timer.sleep 1000

#     result = 142
#     # result |> IO.puts
#     # result
#     send caller, { :ok, result } #[4] отправляем ответ/msg
#   end

#   # def do_something_else do
#   def do_something_else(caller) do #[4]
#     :timer.sleep 1000

#     result = 242
#     # result |> IO.puts
#     # result
#     send caller, { :ok, result } #[4] отправляем ответ/msg
#   end

# end

# #=======[1]========
# # results = [Demo.do_this(), Demo.do_that(), Demo.do_something_else()]
# # results |> IO.inspect
# # 42
# # 142
# # 242
# # [42, 142, 242]

# #========[2]spawn / многоядерн выполнение=====
# # results = [
# #   spawn(Demo, :do_this, []), #(модуль, функ модуля, [список передав аргументов])
# #   spawn(Demo, :do_that, []),
# #   spawn(Demo, :do_something_else, [])
# # ]

# # results |> IO.inspect
# # #вып одновременно (!)порядок вып произвольный(

# #========[4]как вытащить промеж рез работы функций?============
# caller = self()

# #======[4.1]===============
# # results = [
# #   spawn(Demo, :do_this, [caller]), #(модуль, функ модуля, [список передав аргументов])
# #   spawn(Demo, :do_that, [caller]),
# #   spawn(Demo, :do_something_else, [caller])
# # ]

# # results |> IO.inspect
# #======[4.2]===============
# do_async =&( spawn(Demo, &1, [caller]) ) #реализ паттерн DRY (dont repeat yourself)

# #====[1]====
# # results = [
# #   do_async.(:do_this), # == spawn(Demo, :do_this, [caller])
# #   do_async.(:do_that),
# #   do_async.(:do_something_else)
# # ]
# #====[2]====
# Enum.each [:do_this, :do_that, :do_something_else], do_async #цикл for

# #ловит ответ (!)1шт, а нужно 3 шт
# fetch_responce = fn(_) ->
#   receive do
#     { :ok, number } -> number

#     after 5000 -> nil #ждёт msg 5 сек (затем завершает попытки получить msg)
#   end
# end

# # Enum.map [ 1, 2, 3 ], fetch_responce #заменит [1,2,3] на [42,142,242] (!)а если 10шт надо?
# results = Enum.map 1..3, fetch_responce #1..3 = диапазон (от 1го до 3х)


# IO.puts "Computing results:"
# results |> IO.inspect           #выводим рез
# # Computing results:
# # [42, 142, 242]

#=======[3]messages (процессы могут общаться между собой)==========
#сообщ - передаються асинхронно (между проц)
#когда проц получает msg - оно отпр в спец 'почтовый ящик'(FIFO очередь)
# defmodule Demo do
#   def do_that do
#     IO.puts "doint work..."

#     receive do #читаем msg
#       # {:message_type, value} ->
#       { sender, msg } ->
#         IO.inspect sender
#         IO.puts "I've recieved a message: #{msg}"
#         #=====[2]отправим ответ/msg (отправителю)=========
#         send sender, {self(), "Hello to you too!"}

#       after 1000 -> IO.puts "I haven't recieved any messages :("
#     end

#   end
# end

# pid = spawn Demo, :do_that, [] #pid = #PID<0.101.0> (исп его можно к нему писать/отпр msg)
# # send pid, "Hello!" #отправили процессу msg "Hello!"
# send pid, { self(), "Hello!" }
# #PID<0.103.0>
# #I've recieved a message: Hello!

# #======[2]============
# receive do #читаем msg
#   { sender, msg } ->
#     IO.inspect sender
#     IO.puts "I've recieved a responce: #{msg}"

#   after 1000 -> IO.puts "I haven't recieved any messages :("
# end
# # doint work...
# ##PID<0.103.0>
# # I've recieved a message: Hello!
# # #PID<0.110.0>
# # I've recieved a responce: Hello to you too!

#=======[5]linked_processes / цепочка процессов===========
# defmodule Demo do
#   def do_work do
#     IO.puts "doing work..."
#     # exit(:error) # :normal #exit(:error) = процесс завершился аномально/сломался
#     1 / 0
#   end
# end

# Process.flag(:trap_exit, true) #отслеживать "вылет" (!)так прога "не вылетит" если багнеться один из созданных процессов

# spawn_link Demo, :do_work, [] #создали цепь процессов
# # doing work...
# # ** (EXIT from #PID<0.103.0>) :error

# #cловим предсмертный msg (процесс отпр такой при "вылете")
# receive do
#   msg -> IO.puts "The linked proccess says: #{inspect(msg)}"
# end
# #The linked proccess says: {:EXIT, #PID<0.110.0>, :error}

#=======[6]monitors===========
# defmodule Demo do
#   def do_work do
#     IO.puts "doing work..."
#     exit(:error)
#   end
# end

# spawn_monitor Demo, :do_work, [] #мониторим процесс

# receive do
#   msg -> IO.puts "The monitored process says: #{inspect(msg)}"

#   after 5000 -> IO.puts "The monitored process says nothing."
# end
# # doing work...
# # The monitored process says: {:DOWN, #Reference<0.4237534287.4123000841.52619>, :process, #PID<0.110.0>, :error}

#=======[7]pmap / parallel_mapping===========
defmodule Demo do
  def pmap(n) do
    #породим 'n' процессов И прочтём 'n' штук их msg-ей
    (1..n) |> Enum.map(&Demo.do_spawn/1) |> Enum.map(&Demo.do_receive/1)
  end

  def do_spawn(elem) do
    f = &(&1 * &1) # квадрат числа

    spawn_link Demo, :calc, [ self(), f, elem]
  end

  def calc(that_process, f, elem) do
    send that_process, { self(), f.(elem) }
  end

  def do_receive(pid) do
    receive do
      { ^pid, result } -> result #без ^ - рез будут непоследовательно/вперемешку
    end
  end

  #замер time сущ процессов
  def run(n) do
    { ms, res } = :timer.tc(Demo, :pmap, [n])
    { ms / 1000, res }
  end
end

# Demo.run(5) |> IO.inspect()
Demo.run(100_000) |> IO.inspect() #за 0,4 секунды создали 100к процессов
# {438.784,
#  [1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 256, 289, 324,
#   361, 400, 441, 484, 529, 576, 625, 676, 729, 784, 841, 900, 961, 1024, 1089,
#   1156, 1225, 1296, 1369, 1444, 1521, 1600, 1681, 1764, 1849, 1936, 2025, 2116,
#   2209, 2304, ...]}


#elixir -r proc.exs -e "Demo.run(100_000) |> IO.inspect()"
#elixir -r proc.exs -e "Demo.run(5) |> IO.inspect()"
