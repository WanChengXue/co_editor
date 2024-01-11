defmodule CoEditorBackendWeb.RedisClient do
  @moduledoc false

  def start_link do
    # {:ok, redis_conn} = Redix.start_link("redis://localhost:6379/3", name: :redix)
    {:ok, redis_conn} = Redix.start_link("redis://localhost:6379/3")
    Process.put(:redis_conn, redis_conn)
  end

  def command(command, args) do
    case Process.get(:redis_conn) do
      nil ->
        start_link()
        result = Redix.command(:redix, [command | args])
        handle_result(result)
      redis_conn ->
        result = Redix.command(redis_conn, [command | args])
        handle_result(result)
    end
  end

  defp handle_result({:ok, result}), do: result
  defp handle_result({:error, reason}), do: {:error, reason}
end
