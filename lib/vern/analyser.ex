defmodule Vern.Analyzer do
  import Tirexs.Percolator
  alias Tirexs.{Percolator, HTTP, ElasticSearch}

  @settings ElasticSearch.config

  @spec save_phrase_query(String.t, String.t) :: any
  def save_phrase_query(phrase, response) do
    percolator([index: "messages", name: phrase, response: response])  do
      query do
      match "message", phrase
      end
    end
    |> Percolator.create_resource(@settings)
  end

  def analyze(message) do
    percolator([index: "messages", type: "message"]) do
      doc do
        [[message: message]]
      end
    end
    |> Percolator.match(@settings)
    |> case do
      {:ok, 200, result} -> result.matches 
      _ -> []
    end
    |> Enum.map(&get_response/1)
    #|> Enum.filter(&is_binary/1)
  end

  def get_response(match) do
    ElasticSearch.get("messages/.percolator/#{match._id}", @settings) 
     |> case do
        {:ok, 200, %{ _source: %{ response: response }}}-> response
       _ -> nil
     end
  end
end
