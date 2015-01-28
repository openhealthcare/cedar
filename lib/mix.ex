defmodule Mix.Tasks.Cedar do
  use Mix.Task
  require Amnesia

  defmodule Database do

    @actions ["create", "dump", "delete"]
    @shortdoc """
    Creates or destroys the mnesia database used by CEDAR for storing
    variables.
    """

    @moduledoc """
    This mix task can be used for creating, dumping and destroying the CEDAR
    database that is used for storing variables.

          mix cedar.database create

          mix cedar.database dump

          mix cedar.database delete
    """
    def run(_) do
      [ _ | action ] = System.argv
      case hd(action) in @actions do
        false -> IO.puts "Action not recognised, use create, dump or delete"
        true ->
          execute(hd(action))
      end
    end

    defp execute(action) do
      case action do
        "create" -> create
        "dump" -> dump
        "delete" -> delete
      end
    end

    defp create do
      IO.puts "Creating database ..."

      Amnesia.Schema.create
      Amnesia.start

      Db.create(disk: [node])
      Db.wait

      IO.puts "Creating initial data ..."
      Amnesia.transaction do
        Db.Variable.add_variable("admin_email", "support@openhealthcare.org.uk", nil)
      end

      Amnesia.stop
    end

    """
    """
    defp dump do
      Amnesia.start
      Amnesia.transaction do
        # TODO: Fix me, I am horribly broken.
        Db.Variable |> Amnesia.Selection.values |> Enum.each &IO.inspect(&1)
      end
      Amnesia.stop
    end

    defp delete do
      IO.puts "Deleting database ..."

      Amnesia.start
      Db.destroy
      Amnesia.stop
      Amnesia.Schema.destroy
    end

  end


end