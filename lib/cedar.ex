defmodule Cedar do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      worker(Cedar.Endpoint, []),
      worker(Cedar.Decider, []),
      worker(Cedar.Audit, []),
      worker(Cedar.Repo, []),
      worker(Cedar.VarServer, [])
    ]
  
    opts = [strategy: :one_for_one, name: Cedar.Supervisor]
    Supervisor.start_link(children, opts)

  end

  def stop do
    IO.puts "Stopping!"
    :ok
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Cedar.Endpoint.config_change(changed, removed)
    :ok
  end
end
