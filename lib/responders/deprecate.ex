defmodule Vern.Responders.Deprecate do
  use Hedwig.Responder

  hear ~r/deprecate \"(?<word>.*)\" in favor of \"(?<replacement>.*)\"/i, msg do
    define(msg.matches["word"], msg.matches["replacement"])
    reply msg, "Term #{msg.matches["word"]} Deprecated"
  end

  def define(word, replacement) do
    Vern.Analyzer.save_phrase_query(word, "#{word} has been DEPRECATED in favor of #{replacement}")
  end
end
