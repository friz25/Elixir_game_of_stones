# 3) Модули, функции, арность, пограничные условия

# defmodule TopLevel do
#   #...
#   defmodule Nested do
#     def my_func do
#       "hi" |> IO.inspect
#     end

#     def my_func2(text) do
#       text |> IO.inspect
#       1 + 2
#     end

#     def calc(a, b), do: a * b #однострочник

#     defp private_func do #private функция
#       #...
#     end
#   end

#   defmodule Nested2 do
#     #...
#   end
# end

# defmodule TopLevel.Nested do
  #...
# end

# defmodule TopLevel.Nested2 do
  #...
# end
#=======[1]=========
# TopLevel.Nested
# #За кулисами - все модули это Атомы :
# TopLevel.Nested == :"Elixir.TopLevel.Nested"

# IO.inspect TopLevel.Nested == :"Elixir.TopLevel.Nested" #True

# :random.uniform 5 #сген рендомн число 1-5

#=======[2]=========
# TopLevel.Nested.my_func #"hi"
# TopLevel.Nested.my_func2 "hi" #"hi"
# "hi" |> TopLevel.Nested.my_func2 #"hi"
# result = "hi" |> TopLevel.Nested.my_func2
# result |> IO.inspect #3

# 3 |> TopLevel.Nested.calc(2) |> IO.inspect # 3 * 2 и вывести на экран
#=======[3] атрибуты=========
# defmodule Demo do
#   @language "Elixir"
#   @year 2011

#   def func, do: @year + 10

#   def language, do: @language
# end

# ## Demo.@language #error
# # Demo.func() |> IO.inspect #2021

# # Demo.language() |> IO.inspect #"Elixir"

# defmodule Importer do
#   # import Demo
#   alias Demo, as: D
#   # import IO

#   def run do
#     # Demo.func
#     # func |> IO.inspect() #error
#     # func() |> IO.inspect() #ok (если есть 'import Demo')
#     # func() |> inspect() #error (inspect() одноврем в модулях IO и Kernel)

#     D.func() |> IO.inspect() #ok
#   end
# end

# Importer.run #2021
#=======[4] арность функций=========
#(!)В Elixir можно создавать много функций с одинаковым именем!
# но чтоб разное число входных переменных (разная арность)
# defmodule Demo do
#   # Arity 1
#   # def mult(a), do: a * a
#   def mult(a), do: mult(a, a) #в mult/1 вызываем mult/2
#   # Arity 2 (потому что она/функция принимает 2 аргумента)
#   def mult(a, b), do: a * b

#   # def divide(a, b \\ 1) do #b=необяз аргумент + default_value=1
#   #   a / b
#   # end
#   def divide(a), do: divide(a, 1)

#   def divide(a, 0), do: 0 #pattern matching позволяет избежать "деление на ноль"

#   def divide(a, b), do: a / b
# end

# # Demo.mult 2 #4
# # 2 |> Demo.mult |> IO.inspect #4

# # Demo.mult 2, 3 #6
# # 2 |> Demo.mult(3) |> IO.inspect #6

# # Demo.mult/1
# # Demo.mult/2

# Demo.divide(3, 0) |> IO.inspect() #0
# Demo.divide(3) |> IO.inspect()    #3.0
# Demo.divide(4, 3) |> IO.inspect() #1.3333333333333333
#=======[5] Guard clauses=========
#Guard clauses = пограничные условия (которые говорят какую функцию нужно вызвать)
#пример: 'when is_integer(b)' (смотри ниже)
defmodule Demo do
  def divide(_a, 0), do: 0

  # def divide(a, b) when is_integer(b), do: a / b
  # def divide(a, b) when is_number(b), do: a / b
  def divide(a, b)
    when is_number(a) and is_number(b), do: a / b

  #fallback (как finally)
  def divide(_, _), do: nil
end

# Demo.divide(3, "test")
Demo.divide(3, "test") |> IO.inspect()

#Еще виды Guard clauses/пограничные условия :
# Comparison operators == > < >= <=
# Arithmetic + - * /
# Boolean: and, or, !,
# in (входит ли перем в множество)
# ++ <> (чтоб обьединять списки и строки)
# Type-check functions: is_number, is_list, is_atom, ...
# Built-in functions: abs/1 elem/2 length/1
#(!)нельзя использовать собственные/кастомные чеки/функции(

# Домашнее Задание / Задача
## Demo.factorial/1
## n
## factiorial(5) ==> 1 * 2 * 3 * 4 * 5
