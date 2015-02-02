defmodule Cedar.Audit do
  require Logger
  use Continuum

  def start_link do
    logdir = Application.get_env(:auditor, :location)
    log_filename(logdir)
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
    {{year, month, day}, {hour, min, sec}} = DateTime.now
    uniq = "generate_something_unique"
    IO.puts "#{logdir}/#{year}/#{month}/#{day}/#{hour}/#{min}_#{sec}_#{uniq}.log"
    ""
  end

  def audit(logdir) do
    receive do
      { :sucess, behaviour, pre, post } ->
        # Create log_filename()
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