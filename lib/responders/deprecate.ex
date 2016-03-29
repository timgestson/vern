defmodule Vern.Responders.Deprecate do
  use Hedwig.Responder

  hear ~r/deprecate \"(?<word>.*)\" in favor of \"(?<replacement>.*)\"/i, msg do
    status = define(msg.matches["word"], msg.matches["replacement"])
    case status do
      :ok -> 
        reply msg, "Term #{msg.matches["word"]} has been deprecated"
      {:error, message} ->
        reply msg, "Term unable to be deprecated: #{message}"
    end
    status
  end

  @spec define(String.t, String.t) :: :ok | {:error, String.t}
  def define(word, replacement) do
    Vern.Analyzer.save_phrase_query(word, "#{word} has been Deprecated in favor of #{replacement}")
  end
end
