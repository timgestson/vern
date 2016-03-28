defmodule Mix.Tasks.Vern.Create.Index do
  use Mix.Task

  def run(_) do
    import Tirexs.Mapping
    Mix.shell.info "Creating Index" 
    index = [index: "messages", type: "message"]
    mappings do
      indexes "message", type: "string"
      indexes "user", type: "string", index: "not_analyzed"
      indexes "room", type: "string", index: "not_analyzed"
    end

    {:ok, _resp, _body} = Tirexs.Mapping.create_resource(index)
  end
end
