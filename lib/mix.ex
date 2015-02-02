defmodule Mix.Tasks.Cedar do
  use Mix.Task
  require Amnesia

  defmodule Database do

    @actions ["create", "dump", "load", "delete"]
    @shortdoc """
    Creates or destroys the mnesia database used by CEDAR for storing
    variables.
    """

    @moduledoc """
    This mix task can be used for creating, dumping and destroying the CEDAR
    database that is used for storing variables.

          mix cedar.database create

          mix cedar.database dump <filename>

          mix cedar.database load <filename>

          mix cedar.database delete
    """
    def run(_) do
      #IO.inspect System.argv

      [action,args] = case length(System.argv) do
        2 -> [Enum.fetch!(System.argv, 1), []]
        3 -> [Enum.fetch!(System.argv, 1), Enum.fetch!(System.argv, 2)]
      end

      case action in @actions do
        false -> IO.puts "Action not recognised, use create, dump or delete"
        true -> execute(action, args)
      end
    end

    defp execute(action, args) do
      case action do
        "create" -> create args
        "dump" -> dump args
        "load" -> load args
        "delete" -> delete args
      end
    end

    """
    Creates the new database, by default it'll write it to a folder called
    Mnesia.nonode@nohost in the current directory, which is fine for now.

    Sets up some basic variables.
    """
    defp create(_args) do
      IO.puts "Creating database ..."

      Amnesia.Schema.create
      Amnesia.start

      Db.create(disk: [node])
      Db.wait

      IO.puts "Creating initial data ..."
      Amnesia.transaction do
        Db.Variable.add_variable("admin_email", "support@openhealthcare.org.uk", "CEDAR")
      end

      Amnesia.stop
    end

    """
    Loads a database from a previously dumped database.  You need to create the database
    before you can load into it.
    """
    defp load(filename) do
      IO.puts "Loading the database from #{filename}"

      Amnesia.start
      Db.wait

      Amnesia.transaction do
        String.to_char_list(filename) |> Amnesia.load
      end
      Amnesia.stop
    end

    """
    Dumps all of the database into the filename specified.
    """
    defp dump(filename) do
      IO.puts "Dumping the database to #{filename}"

      Amnesia.start
      Db.wait

      Amnesia.transaction do
        String.to_char_list(filename) |> Amnesia.dump
      end
      Amnesia.stop
    end

    """
    Deletes the database. Empties the directory, but leaves the
    directory itself in place.
    """
    defp delete(_args) do
      IO.puts "Deleting database ..."

      Amnesia.start
      Db.destroy
      Amnesia.stop
      Amnesia.Schema.destroy
    end

  end


end