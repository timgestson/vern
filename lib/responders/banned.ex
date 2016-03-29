defmodule Vern.Responders.Banned do
  use Hedwig.Responder

  hear ~r/ban \"(?<subject>.*)\" for \"(?<reason>.*)\"/i, msg do
    status = define(msg.matches["subject"], msg.matches["reason"])
    case status do
      :ok -> 
        reply msg, "Term #{msg.matches["subject"]} has been banned"
      {:error, message} ->
        reply msg, "Term unable to be banned: #{message}"
    end
    status
  end
  
  @spec define(String.t, String.t) :: :ok | {:error, String.t}
  def define(subject, reason) do
    Vern.Analyzer.save_phrase_query(subject, "#{subject} has been banned due to #{reason}")
  end
end
