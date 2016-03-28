defmodule Vern.Responders.Define do
  use Hedwig.Responder

  hear ~r/define \"(?<subject>.*)\" as \"(?<definition>.*)\"/i, msg do
    define(msg.matches["subject"], msg.matches["definition"])
    reply msg, "Term Defined"
  end

  def define(subject, definition) do
    Vern.Analyzer.save_phrase_query(subject, "#{subject}: #{definition}")
  end
end
