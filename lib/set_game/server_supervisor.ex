defmodule SetGame.ServerSupervisor do
  use Supervisor

  @name SetGame.ServerSupervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_server(game) do
    Supervisor.start_child(@name, [game])
  end

  def init(:ok) do
    supervise([
      worker(SetGame.GameServer, [])
    ], strategy: :simple_one_for_one)
  end
end
