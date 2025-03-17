#=====Планировкщики===========

#функция считает "числа Фибоначи"
defmodule FibSolver do
  def fib(scheduler) do
    send scheduler, { :ready, self() }

    receive do
      { :fib, n, client } -> #считай фибоначи {до такого числа, pid того кто запросил}
        send(client, { :answer, n, fib_calc(n), self() })

        fib(scheduler)

        { :shutdown } -> exit(:normal)
    end
  end

  defp fib_calc(0), do: 0
  defp fib_calc(1), do: 1
  defp fib_calc(n), do: fib_calc(n - 1) + fib_calc(n - 2)
end

defmodule Scheduler do
  #указ {скок процесов породить, какой модуль вызвать, какую (его) функ, [список чисел фибоначи]}
  def run(num_processes, module, func, to_calculate) do
    (1..num_processes) |>
    Enum.map(fn(_) -> spawn(module, func, [ self() ]) end) |> #(для Х процессов) породить проц {модуль, функ, свой pid}
    schedule_processes(to_calculate, []) #{что посчитать, [сюда записать результаты]}
  end

  defp schedule_processes(processes, queue, results) do
    receive do
      { :ready, pid } when queue != [] -> #когда 'готов считать' то
        [ next | tail ] = queue # выделяем след элем (списка)

        pid |> send({ :fib, next, self() }) # отпр msg 'считай' fib для 'next'

        schedule_processes(processes, tail, results) #повторяем (с оставш)/"сохраняем состояние"

      { :ready, pid } -> # когда "считать уже нечего"
        pid |> send({ :shutdown })

        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, results) #удалим уже заверш процесс (из списка запущенных)
          #и что {сейчас у нас вот такая очередь, вот такие результаты}
        else #если процессов=0 ТО знач мы "всё посчитали + все проц завершили"
          Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end) #сорт по возрастанию / "чтоб n1 меньше n2" и т.д.
        end

      { :answer, number, result, _pid } ->
        schedule_processes(processes, queue, [ { number, result } | results ])
        #если пришёл 'ответ' > запусти процесс{с тем же списком процессов, с той же очередью, [в список/итог рез добавим (еще один эл) {число, результат вычислений}]}
    end
  end
end

#Задача 6 раз x посчитать последов фибоначи (для числа 35)
to_process = List.duplicate(35, 6) #сделает список [35,...6 раз...]

Enum.each 1..10, fn num_processes -> #цикл запустит 10 процессов
  { time, result } = :timer.tc( #будем замерять время
    Scheduler, :run, [ num_processes, FibSolver, :fib, to_process ]
    #мол запуск Scheduler.run(num_processes, module, func, to_calculate)
    #тоесть запуск (в 1,2,3..10 процессов) FibSolver.fib  {посчитай 6 раз x последов фибоначи для числа 35}
    #и ниже увидим сравнение (быстрее считать в 1 проц ил в 10 ??)
  )

  if num_processes == 1 do
    IO.puts(inspect result)
    IO.puts "\n # time (s)"
  end

  :io.format "using~2B processes it took ~.2f~n", [num_processes, time / 1000000.0] #чтоб в секундах
end
# using 1 processes it took 0.76
# using 2 processes it took 0.40
# using 3 processes it took 0.27
# using 4 processes it took 0.27
# using 5 processes it took 0.26
# using 6 processes it took 0.14
# using 7 processes it took 0.14
# using 8 processes it took 0.14
# using 9 processes it took 0.14
# using10 processes it took 0.14

#Домашнее задание:
