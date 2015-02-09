defmodule Cedar.AuditChannel do
  use Phoenix.Channel


 def join("audit:all", _message, socket) do
    {:ok, socket}
  end

  def leave(_reason, socket) do
    {:ok, socket}
  end

end