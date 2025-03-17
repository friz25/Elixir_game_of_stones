# 4) Рекурсия (списка, голова, хвост, хвостовая оптимизация)
# (!)в Elixir нет циклов for/while !!!
# Решение: всё реализовываем через рекурсию (вот почему она так важна)

# defmodule Demo do
#   def ask_number, do: ask_number() #вечный цикл / завис проги
# end

#=== цель1 - валидация (того что юзер ввёл (с клавиатуры))
# defmodule Demo do
#   def ask_number do
#     IO.gets("Пожалуйста введите число (Int): ") |>
#     Integer.parse |> #преобразовали в целое число/Integer
#     check_input #чек/верификация результата/преобразования
#   end

#   defp check_input(:error), do: ask_number() #если 'error' > перезапустим функцию
#   defp check_input({number, _}), do: number #(если всё ок) вернём целую часть (числа)
# end

# # Integer.parse "42"
# # # {42, ""}
# # Integer.parse "42.5"
# # # {42, ".5"}
# # Integer.parse "error"
# # #error

# Demo.ask_number() |> IO.puts()
# Пожалуйста введите число (Int): asdasd
# Пожалуйста введите число (Int): asdas
# Пожалуйста введите число (Int): 42
# 42

#=== цель2 - "проход по списку"================
# head = 1й элемент списка
# tail = все остальные/оставшиеся элементы
# a = [1,2,3,4,5]
# hd a #1
# tl a #[2,3,4,5]
# b = tl a
# hd b #2
# tl b #[3,4,5] и так далее

# a = [1]
# hd a #1
# tl a #[]

# [ head | [nested_head | nested_tail] ] = [1, 2, 3]
# head #1
# nested_head #2
# nested_tail #[3]

# list_a = [1, 2, 3]
# list_b = [1 | [2 | [3] ] ]
# list_a == list_b #True

# #оч быстрая опирация (добавл 1го элемента (слева))
# list = [1,2,3]
# new_el = 0
# new_list = [ new_el | list ] #[0,1,2,3]

# # tail-call optimization
# defmodule Demo do
#   def recur(n) do
#     recur(n) * 2 # no optimization!
#   end

#   def iterate([]), do: IO.puts("end of the list!")
#   def iterate([ head | tail ]) do
#     head |> IO.puts()

#     tail |> iterate() # => optimization!
#   end
# end

# Demo.iterate([1,2,3,4])
# 1
# 2
# 3
# 4
# end of the list!

#=== цель3 - посчитать длинну списка (кол элем-тов)==========
#(!)если вы знаете что у вас (будет) безразмерный список
# ТО цикл нужно (обяз) оптимизировать

defmodule Demo do
  # def len([]), do: 0
  # def len([_h | tail]), do: len(tail) + 1 #no optimization!

  def len(initial_list), do: do_len(0, initial_list)

  defp do_len(total_length, [ _h | tail ]) do
    do_len(total_length + 1, tail) # optimized!
  end

  defp do_len(total_length, []), do: total_length
  #====[4]span/2============
  def span(from, to), do: do_span([], from, to)

  defp do_span(list, from, to) when from > to, do: list

  defp do_span(list, from, to) do
    do_span([to | list], from, to - 1)
  end
  #====[5]max/1============
  def max([ value | [ head | tail ] ]) when value < head do
    max([ head | tail ])
  end

  def max([ value | [ head | tail ]]) when value >= head do
    max([ value | tail ])
  end

  def max([ value ]), do: value #когда остался один (знач макс) ТО вернём его
end

# [1,2,3,4] |> Demo.len() |> IO.puts() #4
#=== цель4 - вернуть список (от числа X до числа Y)======
# 2 |> Demo.span(10) |> IO.inspect() #[2, 3, 4, 5, 6, 7, 8, 9, 10]
# 10 |> Demo.span(2) |> IO.inspect() #[]
# 2 |> Demo.span(10) |> Demo.len() |> IO.inspect() #9
#=== цель5 - найти макс число (в списке)======
[1, 2, 10, 4] |> Demo.max() |> IO.inspect() #10

# Домашнее задание
#1) span/2 "сделать более надёжной"/(сейчас) если один из арг будет неЦелое то error
#2) реализовать когда 1й > 2го # 10 |> Demo.span(2) |> IO.inspect() #[]
#3) max/1 "сделать более надёжной"/(сейчас) если один из арг будет неЦелое то error
#4) напишите функ keep_odd/1 должна принять список А вернуть список (только нечётных)
#так чтоб Demo.keep_odd([1,2,4,10,3,101]) #1,3,101
#(!)чтоб была с 'хвостовой оптимизацией'
