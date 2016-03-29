defmodule Vern.Responders.Listen do
  use Hedwig.Responder

  hear ~r/^(?!vern)(.+)$/i, msg do
    msg.text 
    |> Vern.Analyzer.analyze
    |> Enum.map(&(reply(msg, &1))) 
  end
end
