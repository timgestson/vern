defmodule Vern do
 use Application

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec
    options  = [strategy: :rest_for_one, name: Vern.Supervisor]
    children = [worker(Vern.Robot, [])]
    Supervisor.start_link(children, options)
  end

end
