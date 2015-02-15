defmodule Cedar.Audit do
  alias Poison, as: JSON
  require Logger
  use Continuum
  require Cedar.AuditChannel

  def start_link do
    logdir = Application.get_env(:auditor, :location)
    Logger.info "Audit to #{logdir}"

    pid = spawn fn -> audit logdir end
    Phoenix.PubSub.subscribe(Cedar.PubSub, pid, "audit")

    Phoenix.PubSub.broadcast Cedar.PubSub,"audit", {:fail, "Startup", %{}, %{}, ""}
    {:ok, pid}
  end

  """
  Returns the name for a new file within log dir based on the
  time/date etc.

  Builds a directory structure based on the current date and time

    logs/year/month/day/hour/<timestamp>.log
  """
  defp log_filename(logdir, id) do
    {{year, month, day}, {hour, min, sec}} = DateTime.now

    p = Path.join([logdir, "#{year}", "#{month}", "#{day}", "#{hour}"])
    {p, "#{min}_#{sec}_#{id}.log"}
  end

  """
  Convert all of the arguments into a map where the keys have the same
  name as the params. Almost certainly a cleaner way of doing this.
  TODO: Investigate nicer way...
  """
  defp get_map(success, behaviour, pre, post, _endpoint, id ) do
    %{
        "success" => success,
        "behaviour" => behaviour,
        "pre" => pre,
        "post" => post,
        "id" => id,
    }
  end

  @doc  """
  Accepts messages from other processes and writes them to an audit
  file as a JSON blob.
  """
  def audit(logdir) do
    receive do
      { retcode, behaviour, pre, post, endpoint, id } ->
        {path, name} = log_filename(logdir, id)
        File.mkdir_p(path)

        # Log timestamp and data to file
        data_dict = get_map(retcode == :success, behaviour, pre, post, endpoint, id)
        {:ok, encoded} = JSON.encode(data_dict)
        File.write!(Path.join([path, name]), "#{encoded}\r\n", [:append])
        IO.puts "Wrote log entry to #{Path.join([path, name])}"

        # Broadcast audit log to listeners
        Cedar.Endpoint.broadcast("audit:all", "new:message", data_dict)
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