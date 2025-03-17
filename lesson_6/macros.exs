#6) Ветвление, ошибки, структуры данных, kw lists
# defmodule Demo do
#   def run(n) do
#     #=====[1] if / else======
#     # if n > 20 do
#     #   "truthy"
#     # else
#     #   "falsey" # => false / nil
#     # end

#     # if n > 20, do: "", else: ""
#     # unless n > 20, do: "", else: "" #делает "наоборот"/логическое "ЕслиНе"

#     #======[2]cond==========
#     # result = cond do  #cond = CONDITION
#     #   n > 100 -> "large"
#     #   n <= 100 and n >=50 -> "avg"
#     #   n > 20 and n < 50 -> "small"
#     #   true -> "very small" # fallback
#     # end

#     #======[3]case==========
#     # result = case n > 100 do
#     #   true -> "large"
#     #   false -> "small"
#     # end

#     case File.open("demo.txt") do
#       { :ok, io_dev } -> IO.read(io_dev, :line) #прочитать строку
#       { :error, reason } -> IO.puts(reason)
#       _ -> IO.puts("unexpected error") # fallback
#     end

#     result |> IO.inspect()
#   end
# end

# Demo.run(42) #"small"
# # 42 |> Demo.run() |> IO.inspect()

#===============[2]exceptions=================
# defmodule Demo do
#   def run do
#     try do
#       # 1 / 0
#       # { :ok, io_device } = File.open("demo.txt")
#       raise "ERROR"
#       raise ArithmeticError, "ArithmeticERROR"
#     rescue
#       # error -> IO.inspect(error)
#       error in ArithmeticError -> IO.inspect(error)
#       MatchError -> IO.puts("cannot open file")
#       error -> IO.inspect(error) #%RuntimeError{message: "ERROR"}
#     end
#   end
# end

# Demo.run()
#===============[3]types=================
# defmodule Demo do
#   #========[1]тип KeywordList применяют (в осн) так:======
#   @default_opts [ mode: "r", filename: "demo.txt" ] #список опций
#   # @default_opts2 [ mode: "r", filename: "demo2.txt" ]
#   # @default_opts3 [ mode: "r", filename: "demo3.txt" ]

#   def run(_arg, opts \\ []) do
#     opts = Keyword.merge(@default_opts, opts)
#     opts |> IO.inspect()
#   end
# end

# Demo.run(4, [ mode: "a+" ]) #[filename: "demo.txt", mode: "a+"]
#==================[2]сложные структуры данных=========
defmodule User do
  #===========[1]========
  defstruct name: "",
            surname: "",
            age: 0,
            role: :member

  #=================[2]==================
  # def show(user) do
  # def show(user = %User) do #принимает только обьект типа User
  # def show(user = %User{name: "John"}) do #принимает только John'ов ахаха
  # def show(user = %User{name: name}) when name != "" do #принимает только с заполненным именем
  #   user |> IO.inspect() # выводит юзера
  # def show(%User{name: name, surname: surname}) when name != "" do #принимает только с заполненным именем
  #   IO.puts "Name: #{name}, surname: #{surname}" #Name: John, surname: Doe
  def show(user = %User{name: name, surname: surname}) when name != "" do #принимает только с заполненным именем
    IO.puts "Name: #{user.name}, surname: #{user.surname}" #Name: John, surname: Doe
  end

  #=======[3]===========
  def update(user = %User{}, new_name) do
    %User{ user | name: new_name }
  end
end

#=======[4]вложенные сложн структ=======
defmodule Department do
  defstruct title: "",
            employees: [],
            head: %User{}
end

defmodule Demo do
  def run do
    m = %{name: "test", surname: "test2"} #обычный Map (как Dict)
    user = %User{ name: "John", surname: "Doe", age: 40, role: :admin }

    user |> User.show() #Name: John, surname: Doe

    #=====[3]изменим имя юзера/сотрудника========
    updated_user = user |> User.update("Jim")

    updated_user |> User.show() #Name: Jim, surname: Doe

    #=====[4]=========
    department = %Department{
      title: "IT",
      employees: [updated_user],
      head: updated_user
    }
    #===добавим сотрудника (в department)=====
    user = %User{ name: "Ann", surname: "Smith", age: 20, role: :member }

    department = %Department{
      department | employees: [ user | department.employees ]
    }

    department |> IO.inspect()

    #====[5]изменим возраст юзера (из этого department)====
    # department = update_in(department.head.age, "59")
    department = update_in(department.head.age, &(&1 + 1)) #подняли возраст на 1 год
    department = put_in(department.head.name, "FRIZ")

    department |> IO.inspect()
  end
end

Demo.run() # %User{name: "John", surname: "Doe", age: 40, role: :admin}

#Домашнее задание
#1) Переписать (5 урок)'Матрицу' используя эти макросы (case, if else)
#2) применить в ней обработку ошибок (raise, rescue, erro, case) (напр при открытии файла)
