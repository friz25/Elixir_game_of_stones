#9) Перечисления, enum, stream, списковые включения (32m)

#==========[1]enum===========
# defmodule Demo do
#   def run do
#     #как "слепить" два списка (воедино)
#     # [1,2] ++ [3,4] #[1,2,3,4]
#     # [1,2] |> Enum.concat([3,4]) #то же самое
#     # [1,2,3,4] |> Enum.join(",") #"1,2,3,4" #в строку
#     # (1..10) |> Enum.at(5, :unknown) #6 #верни 5й эл (из списка)
#     # Enum.each([1,2,3], fn(x) ->
#     #   x |> IO.inspect()
#     # end)
#     ## 1
#     ## 2
#     ## 3
#     ## :ok
#     # Enum.map([1,2,3], fn(x) -> #[1, 4, 9]
#     #   x ** 2
#     # end)
#     # Enum.map([1,2,3], &(&1 ** 2))#то же самое
#     # [1, 3, 10, 5, -1] |> Enum.sort(&(&1 >= &2)) #[10, 5, 3, 1, -1] #сорт по убыв
#     # [1, 3, 10, 5, -1] |> Enum.filter(&(&1 > 0 && &1 < 8)) #[1, 3, 5]
#     # [1, 3, 10, 5, -1] |> Enum.all?(&(&1 > 0)) #false #все эл > 0? Boolean
#     # (1..10) |> Enum.reduce(fn(el, acc) -> #55 #сложил все числа послед-ти
#     #   acc + el
#     # end)
#     Enum.reduce(1..10, &(&1 + &2))#то же самое
#   end
# end

# Demo.run |> IO.inspect()

#==========[2]stream (перебирает "в ленивом формате" (как yield))===========

#========[1]не оптимиз========
# defmodule Demo do
#   def run do
#     (1..10_000_000) |>
#     Enum.map(&(&1 + 1)) |> #бизнес-логика
#     Enum.filter(&(rem(&1, 2) == 0)) |> #фильтруем
#     Enum.with_index |> #возвращает список из кортежей типа (индекс, сам эл)
#     Enum.take(10) #вытаск 10 перв эл
#   end

#   #========[2]оптимиз/stream/lazy========
#   # def run_lazy do
#   #   (1..100) |>
#   #   Stream.map(&(&1 + 1)) |>#бизнес-логика
#   #   # Enum.to_list() #[2, 3, 4, ..., 101]
#   #   Enum.take(10) #[2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
#   def run_lazy do
#     (1..10_000_000) |>
#     Stream.map(&(&1 + 1)) |> #бизнес-логика
#     Stream.filter(&(rem(&1, 2) == 0)) |> #фильтруем
#     Stream.with_index |> #возвращает список из кортежей типа (индекс, сам эл)
#     Enum.take(10) #вытаск 10 перв эл
#   end

#   #========[3]lazy чтение файлов=========
#   def read_file do
#     File.stream!("alice.txt") |>
#     Enum.with_index(1) |> #пронумеруем строки (нач с 1)
#     Enum.filter(fn({str, _n}) ->
#       String.contains?(str, "Queen")
#     end) |>
#     Enum.take(3)
#   end
# end

# Demo.read_file() |> IO.inspect()

# # [1,2,3] |> Enum.with_index |> IO.inspect() #[{1, 0}, {2, 1}, {3, 2}]

# { time, _ } = :timer.tc(
#   Demo, :run, [ ]
# )

# IO.puts(time / 1_000_000.0) #затр время (в секундах)
# # 1.111449

#  #========[2]оптимиз/stream/lazy========
# # Demo.run_lazy |> IO.inspect()
# ##Stream<[enum: 1..100, funs: [#Function<49.117496853/1 in Stream.map/2>]]>

# { time, _ } = :timer.tc(
#   Demo, :run_lazy, [ ]
# )

# IO.puts(time / 1_000_000.0) #затр время (для run_lazy) в секундах
# # 0.008704 /128x быстрее

#========[4]еще примеры lazy===========
# defmodule Demo do
#   def run do
#     #============[1]================
#     #потенциально безразмерная коллекция
#     #не известно скок чисел нужно будет нагенерир (чтоб вышло аж 5 от 20ти до 50ти)
#     # Stream.repeatedly(fn -> :rand.uniform * 100 end) |> #сген случ число (от 0 до 100)
#     # Stream.filter(&(&1 > 20 && &1 < 50)) |>
#     # Enum.take(5)

#     #=============[2]===============
#     #потенциально безразмерная коллекция
#     #будет делить на 2 (неизвестно скок раз / пока не достигнет нужн рез)
#     Stream.unfold(10, fn(x) ->
#       case rem(x,2) == 0 do
#         true -> {x, x + 1}
#         false -> {x, x + 2}
#       end
#     end) |>
#     Enum.take(10)
#   end
# end

# Demo.run |> IO.inspect()
# #====[1]=====
# # [21.872089164655286, 25.5339309394518, 48.42719162127649, 37.41518931105998,
# #  39.08010608168699]
# #====[2]=====
# #[10, 11, 13, 15, 17, 19, 21, 23, 25, 27]

#========[5]list comprehentions / списковые включения/свёртка===========
#lc = набор операция чтоб управлять списков и породить (на его основе) новый список
defmodule Demo do
  require Integer

  # def run(list1) do
  #   # for el <- list1, do: el * 2 #тут lc возвр другой список (из el * 2)
  #   # for el <- list1, rem(el, 2) == 0, do: el * 2 #+добавили критерии фильтрации / тут "если делиться на 2 без остатка > тада хочу его включать в новый список
  #   # for el when el > 10 <- list1, rem(el, 2) == 0, do: el * 2 # "влючать ток эл больше 10"
  #   for el when el > 10 <- list1, Integer.is_even(el), do: el * 2 # то же самое
  # end

  # def run2(list1, list2) do
  #   # for a when a > 10 <- list1, b <- list2, Integer.is_even(b), do: a * b
  #   for a when a > 5 <- list1, b <- list2, Integer.is_even(b),
  #   into: %{}, #но записать в словарь/Map
  #   do: {a, b}
  # end

  #========[2]=========
  @tax 0.1

  #задача - посчитать зп после вычета налогов
  def format_data(employees) do
    for {name, salary} <- employees, into: %{},
    do: {format_name(name), salary - salary * @tax}
  end

  # все именя > в атомы
  defp format_name(name) do
    name |>
    String.downcase |>
    String.to_atom
  end

  #=====[3]со строками=====
  def run(list) do
    for << char <- list >>, do: char - 1 #шифр цезаря (сдвиг каждой буквы на 1 по алфавиту)
  end
end

# (1..100) |> Demo.run |> IO.inspect()
#[2, 4, 6, 8, 10, 12, 14, 16, ...]
#[4, 8, 12, 16, 20, 24, 28, ...]
#[24, 28, 32, 36, 40, 44, 48, ...]

# (1..10) |> Demo.run2((5..10)) |> IO.inspect()
#[66, 88, 110, 72, 96, 120, 78, ...]
#%{6 => 10, 7 => 10, 8 => 10, 9 => 10, 10 => 10}

#==========[2]==============
# %{"Joe" => 50, "Bill" => 40, "Alice" => 45, "Jim" => 30} |> #зп сотрудников (50к $/год)
# Demo.format_data() |> IO.inspect()
# #%{alice: 40.5, bill: 36.0, jim: 27.0, joe: 45.0}

#=====[3]со строками=====
"fmjyjs" |> Demo.run |> IO.inspect() #~c"elixir" #разшмфровал


#Домашнее задание:
#1) Глянуть документацию (другие методы Stream)
#2)Переделать Matrix при помощи стримов + замерить/сравнить время вып (со стримом и без)
