defmodule Amnesia.Test do

  def start do
    Amnesia.start
    Db.wait
  end

  def stop do
    Amnesia.stop
  end
end

ExUnit.start
