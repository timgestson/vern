defmodule Vern.Responders.Define do
  use Hedwig.Responder

  hear ~r/define \"(?<subject>.*)\" as \"(?<definition>.*)\"/i, msg do
    status = define(msg.matches["subject"], msg.matches["definition"])
    case status do
      :ok -> 
        reply msg, "Term #{msg.matches["subject"]} has been defined"
      {:error, message} ->
        reply msg, "Term unable to be defined: #{message}"
    end
    status 
  end

  @spec define(String.t, String.t) :: :ok | {:error, String.t}
  def define(subject, definition) do
    Vern.Analyzer.save_phrase_query(subject, "#{subject}: #{definition}")
  end
end
