defmodule GameOfStones.Application do
  use Application

  def start(_type, _opts) do
    children = [ #это те проц которые хочу запустить И мониторить (с помощью Супервайзера)
      GameOfStones.Server
      # { GameOfStones.Server, 42 } #cо стартовым арг (для Server.start_link)
    ]

    #опции перезапуска(если что-то идёт не так)
    opts = [
      strategy: :one_for_one, #если проц упал > перезапустить
      # strategy: :one_for_all, #если проц упал > перезапустить ВСЕ процессы
      # strategy: :rest_for_one, #если проц упал > перезапустим этот и след процессы (в списке children) после этого
      name: GameOfStones.Supervisor
    ]

    #Supervisor автоматом будет следить за нашим серваком
    Supervisor.start_link(children, opts) #{что мониторить, опции(что делать "если что")}
  end
end
