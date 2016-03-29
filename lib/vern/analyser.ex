defmodule Vern.Analyzer do
  import Tirexs.Percolator
  alias Tirexs.{Percolator, HTTP, ElasticSearch}

  @settings ElasticSearch.config

  @spec save_phrase_query(String.t, String.t) :: :ok | {:error, String.t}
  def save_phrase_query(phrase, response) do
    [index: "messages", name: String.replace(phrase, " ", "_"), response: response] 
    |> percolator do
      query do
        match "message", phrase
      end
    end
    |> Percolator.create_resource(@settings)
    |> case do
      {:ok, _, _} -> :ok
      _ -> {:error, "A problem occured"}
    end
  end

  @spec analyze(String.t) :: list(String.t)
  def analyze(message) do
    [index: "messages", type: "message"]
    |> percolator do
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
    |> Enum.filter(&is_binary/1)
  end

  @spec get_response(%{_id: String.t}) :: String.t | nil
  def get_response(match) do
    "messages/.percolator/#{match._id}"
    |> ElasticSearch.get(@settings) 
    |> case do
       {:ok, 200, %{_source: %{response: response}}} -> response
       _ -> nil
    end
  end
end
