defmodule Metapede.RequestHelpers do
  def convert_to_query_string(query_options) do
    for {k, v} <- query_options do
        "#{k}=#{v}"
    end
  end
end
