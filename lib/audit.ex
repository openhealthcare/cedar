defmodule Cedar.Audit do
  require Logger
  use Continuum

  def start_link do
    logdir = Application.get_env(:auditor, :location)
    Logger.info "Audit to #{logdir}"
    pid = spawn fn -> audit logdir end
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

  def audit(logdir) do
    receive do
      { :sucess, behaviour, pre, post } ->
        {path, name} = log_filename(logdir)

        # Log timestamp and data to file
        nil
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