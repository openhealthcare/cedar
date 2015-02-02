defmodule Cedar.Audit do
  require Logger

  def start_link do
    logdir = Application.get_env(:auditor, :location)
    Logger.info "Audit to #{logdir}"
    pid = spawn fn -> audit logdir end
    {:ok, pid}
  end

  """
  Returns the name for a new file within log dir
  based on the time/date etc.
  """
  defp log_filename(logdir) do
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