defmodule Cedar.Audit do
  alias Poison, as: JSON
  require Logger
  use Continuum

  def start_link do
    logdir = Application.get_env(:auditor, :location)
    Logger.info "Audit to #{logdir}"

    pid = spawn fn -> audit logdir end
    Phoenix.PubSub.subscribe(pid, "audit")

    Phoenix.PubSub.broadcast "audit", {:fail, "Startup", %{}, %{}, ""}
    {:ok, pid}
  end

  """
  Returns the name for a new file within log dir based on the
  time/date etc.

  Builds a directory structure based on the current date and time

    logs/year/month/day/hour/<timestamp>.log
  """
  defp log_filename(logdir) do
    {_, _, ms} = :erlang.now
    {{year, month, day}, {hour, min, sec}} = DateTime.now

    p = Path.join([logdir, "#{year}", "#{month}", "#{day}", "#{hour}"])
    {p, "#{min}_#{sec}_#{ms}.log"}
  end

  defp get_map(success, behaviour, pre, post, endpoint ) do
    m = %{
          "success" => success,
          "behaviour" => behaviour,
          "pre" => pre,
          "post" => post
        }
    JSON.encode(m)
  end

  @doc  """
  Accepts messages from other processes and writes them to an audit
  file as a JSON blob.
  """
  def audit(logdir) do
    receive do
      { retcode, behaviour, pre, post, endpoint } ->
        {path, name} = log_filename(logdir)
        File.mkdir_p(path)

        # Log timestamp and data to file
        {:ok, blob} = get_map(retcode == :success, behaviour, pre, post, endpoint)
        File.write(Path.join([path, name]), blob)
      _ ->  nil
    end
    audit logdir
  end

end

defmodule Mix.Tasks.Audit do
  use Mix.Task

  def run(_) do
  end

end