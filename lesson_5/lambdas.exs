#5) Лямбды, функции высшего порядка, вывод в стиле Матрицы
#=========[1]lambda==============
# # hi = fn -> IO.puts("hi") end
# # hi = fn(msg) -> IO.puts(msg) end
# hi = fn({name, msg}) -> IO.puts("#{msg}, #{name}!") end

# # hi.() #hi
# # hi.("hi") #hi
# hi.({"Ann", "Welcome"}) #Welcome, Ann!
#=========[2]map==============
#map(list, func) применит функц/лямбду func к (кажд) эл списка list

# defmodule Demo do
#   # def map(list, func), do: do_map([], list, func) #[8, 6, 4, 2] неверно/первёрнутый!
#   def map(list, func), do: do_map([], list, func) |> Enum.reverse()

#   defp do_map(new_list, [], _), do: new_list #конец/выход из цыкла //вернуть рез

#   defp do_map(new_list, [ head | tail ], func) do
#     [ func.(head) | new_list ] |> do_map(tail, func)
#   end
# end

# [1,2,3,4] |> Demo.map(
#   fn(x) -> x * 2 end
# ) |> IO.inspect() #[2, 4, 6, 8]
#=========[3]multi_clause_lambdas==============
# # creation_date = fn
# #   "elixir" -> 2011
# #   "ruby" -> 1995
# #   "cpp" -> 1985
# #   lang when is_bitstring(lang) -> "Not sure about '#{lang}'"
# #   _ -> nil
# # end

# # creation_date.("elixir") |> IO.inspect() #2011
# # creation_date.("erlang") |> IO.inspect() #nil   #Not sure about erlang

# defmodule Demo do
#   # def map(list, func), do: do_map([], list, func) #[8, 6, 4, 2] неверно/первёрнутый!
#   def map(list, func), do: do_map([], list, func) |> Enum.reverse()

#   defp do_map(new_list, [], _), do: new_list

#   defp do_map(new_list, [ head | tail ], func) do
#     [ func.(head) | new_list ] |> do_map(tail, func)
#   end
# end

# #=====[1]=========
# # [1,2,3,4] |> Demo.map(
# #   fn(x) -> x * 2 end
# # ) |> IO.inspect() #[2, 4, 6, 8]

# #=====[2]=========
# handler = fn
#   x when is_number(x) ->  x * 2 #если число > применяем операцию
#   x -> x
#   end

# [1,2,3,4,"dog","cat"] |> Demo.map(
#   handler
# ) |> IO.inspect() #[2, 4, 6, 8, "dog", "cat"]
#=========[4]capturing / захватывающий оператор =======
# ## handler = fn(x) -> x * 2 end
# # handler = &(&1 * 2) #то же самое!
# # handler.(2) |> IO.inspect() #4

# # handler = &((&1 * &1) / &2)
# # handler.(4, 2) |> IO.inspect() #8.0  #4 * 4 (16) / 2 = 8

# # handler = fn(x) -> IO.puts(x) end
# # handler = &(IO.puts(&1)) #то же самое!
# handler = &IO.puts/1 #то же самое!

# handler.("hello") #hello
#=========[5]lengths=======================
# ["dog", "cat", "elephant", "mouse"]
# #чтоб каждая строка заменялась числом(своей длинной)
# #чтоб [3, 3, 8, 5]

# # Enum.map ["dog", "cat", "elephant", "mouse"]
# ["dog", "cat", "elephant", "mouse"] |>
# Enum.map(&String.length/1) |>
# IO.inspect() #[3, 3, 8, 5]
# #тоесть список из "к кажд эл примени String.length/1"

# ["dog", "cat", "elephant", "mouse"] |>
# Enum.filter( #в filter() нужно lambda функ (которая возвр Boolean (обяз))
#   &(String.length(&1) >= 4)
# ) |>
# IO.inspect() #["elephant", "mouse"]
#=========[6]closure=======================
#closure - переменные (из окружения) можно юзать внутри лямбд
# num = 3
# handler = &(&1 * num)
# handler.(2) |> IO.inspect() #6
#=========[7]matrix=======================
defmodule Matrix do
  def typewrite(filename) do
    File.open(filename, [:read]) |>
    handle_open() #чек/верификация "смогли ли открыть файл"
      # {:ok, io_device} #ок / смогло открыть файл
      # {:error, reason} #не смогло открыть файл
  end

  defp handle_open({:ok, io_device}) do
    io_device |>
    read_by_line() |> #прочтём построчно #(!)must return io_device
    File.close()
  end

  defp handle_open({:error, reason}), do: reason |> IO.inspect()

  defp read_by_line(io_device) do
    IO.read(io_device, :line) |> # 'строка' или ':eof'
    print_line(io_device)
  end

  defp print_line(:eof, io_device), do: io_device #вернём в File.close()
  defp print_line(string, io_device) do
    do_sleep(500)

    string |>
    String.split("") |>
    Enum.each(&print_char/1)

    # IO.puts(string) #вывести 1 строку (и всё)
    io_device |> read_by_line()
  end

  defp print_char(char) do
    char |> IO.write() #write() чтоб не переходил на новую строку (после кажд буквы)
    do_sleep(100)
  end

  defp do_sleep(n), do: :timer.sleep(n) #кстати, модуль из Erlang
end

"matrix.txt" |> Matrix.typewrite() #Knock-knock, Neo.

#Домашнее задание
#1)чек/верификация "что do_sleep() получает только число *больше нуля
#2)Чтоб каждая строка выводилась "с номера этой строки"
#чтоб:
#1. Knock-knock, Neo.
#2. The Matrix has you.
#3. Follow the white rabbit...
