defmodule Vern.Responders.Listen do
  use Hedwig.Responder

  hear ~r/^(?!vern)(.+)$/i, msg do
    Vern.Analyzer.analyze(msg.text)
    |> Enum.map(&(reply(msg, &1))) 
  end
end
