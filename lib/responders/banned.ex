defmodule Vern.Responders.Banned do
  use Hedwig.Responder

  hear ~r/ban \"(?<subject>.*)\" for \"(?<reason>.*)\"/i, msg do
    define(msg.matches["subject"], msg.matches["reason"])
    reply msg, "Term #{msg.matches["subject"]} has been banned"
  end

  def define(subject, reason) do
    Vern.Analyzer.save_phrase_query(subject, "#{subject} has been banned due to #{reason}")
  end
end
