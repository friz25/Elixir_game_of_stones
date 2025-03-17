#1) Hello World=================
# defmodule DemoModuleLesson1 do
#   def run(str, str2) do
#     #====[1]====================
#     # str = String.reverse(str)
#     # str = String.upcase(str)
#     # IO.inspect(str) #вывод на экран (как print())
#     #====[2]лучше=================
#     str |>
#     String.reverse() |>
#     String.upcase() |>
#     IO.inspect()
#     str2 |> IO.inspect()
#   end
# end

# # DemoModuleLesson1.run("Hello world!") #[1]
# "Hello world!" |> DemoModuleLesson1.run("Second string") #[2]
#2) Типы данных=================
a = 5 # целые числа
b = 1000
c = 3.14 # с плавающей точкой
d = 0.345e3
f = 1_000_000
hex = 0xfa #16ричное число
oct = 0o37 #8ричные
bin = 0b010101010 #бинарные

a + b
a * b
a / b
rem(10, 3) #остаток от деление
div(10, 3) #целая часть от деления

# Atoms (необычн тип данных) *это тип Symbol из языка Ruby
at = :one
at2 = :one # Atom не строка а ссылка на значение
name = :my_name
valid = :valid?

# Boolean
:true
:false
a = true
b = false

# Nil value = значение отсутствует
:nil
nil

# Tuples / Кортежи
t1 = {1, "three", :four, false}
t2 = {2, {3, 4}, :dog, t1}
{:ok, 42} #частый рез функции (неск значений (функ вып успешно + результат (42)))
{:error, "Cannot load data..."}
b = elem {:ok, 42}, 0 #чтоб вытащить 0й элемент из кортежа
b |> IO.inspect() #рез - :ok

my_tuple = {"cat", "dog", 3}
#(!) нельзя изменять кортеж (my_tuple), можно вот так:
new_tuple = my_tuple |> put_elem(1, "snake") #заменим "dog" на "snake"
new_tuple |> IO.inspect() #{"cat", "snake", 3}

# List / Списки
[1, 2, {3, 4}, "dog", ["cat", "snake"], :nil]

# Keyword list (ключ - значение)
my_list = [ title: "Elixir", emerged: 2011 ] #*title и emerged тут это Atoms
[ {:title, "Elixir"}, {:emerged, 2011} ] #вот как это выглядит "за кулисами"

Keyword.get my_list, :title # "Elixir" (тут достали значение ключа title)
my_list |> Keyword.get(:title)

# Maps (как словари/Dict в Python)
data = %{ "title" => "Elixir", :paradigm => "Functional", 2011 => "emerged" }
data[:paradigm] # "Functional"
data[:unknown] # nil
data.paradigm # "Functional" #еще лучше НО:
data.unknown # error! (так что аккуратнее)
#если Атомы то можно короче:
%{:paradigm => "Functional"}
%{paradigm: "Functional"} #одно и то же

# String

## есть Binary Sting (обычная строка)
"test"
"result: #{1 + 2}" #ф-строка / f"{1 + 2}"

##(!) а есть Character lists (строки из списка! целых чисел (каждое число=код определ символа))
#они нужны для обратной совместимостью с некотор пакетами/модулями Erlang
'my string'
'my string #{1 + 2}'
#или
~c"my string"
~c"my string #{1 + 2}"

"a" == 'a' # FALSE (!)акуратнее
a = 'my string'
is_list a # TRUE (это список)
[100, 100] # 'de'
#(!)не совместимы в функциями String
String.reverse('test') #error!

a = IO.gets("Введите имя: ") #"Friz\n" #ввод строки (как input())
String.trim() #обрезаем "всё лишнее"/пробелы в нач и вконце строки
