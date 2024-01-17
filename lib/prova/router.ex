defmodule Prova.Router do
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json", "text/json"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  post "/transform" do
    with {:ok, input} <- parse_input(conn.params),
         {:ok, operation} <- parse_operation(conn.params),
         {:ok, strict} <- parse_strict(conn.params),
         {:ok, response} <- do_transform(input, operation, strict) do
      send_resp(conn, 200, response)
    else
      {:error, _} -> send_resp(conn, 400, "Bad Request")
    end
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end

  defp parse_input(params) do
    case Map.get(params, "input") do
      input when is_binary(input) -> {:ok, input}
      _ -> {:error, :not_a_string}
    end
  end

  defp parse_operation(params) do
    case Map.get(params, "operation") |> String.downcase() do
      operation when is_binary(operation) -> {:ok, String.to_existing_atom(operation)}
      _ -> {:error, :not_a_string}
    end
  end

  defp parse_strict(params) do
    case Map.get(params, "strict") |> String.downcase() do
      "true" -> {:ok, true}
      "false" -> {:ok, false}
      _ -> {:error, :not_a_boolean}
    end
  end

  defp do_transform(input, :upper, true) do
    case String.upcase(input) == input do
      true -> {:error, :already_upper}
      false -> {:ok, String.upcase(input)}
    end
  end

  defp do_transform(input, :upper, false), do: {:ok, String.upcase(input)}

  defp do_transform(input, :lower, true) do
    case String.downcase(input) == input do
      true -> {:error, :already_downcase}
      false -> {:ok, String.downcase(input)}
    end
  end

  defp do_transform(input, :lower, false), do: {:ok, String.downcase(input)}
end
