defmodule Cedar.Api01Controller do
  use Phoenix.Controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end

  def valid_rule(conn, %{"sentence" => sentence}) do
    json conn, Cedar.Matcher.can_evaluate?(sentence)
  end

  def valid_ruledoc(conn, _params) do
    render conn, "valid_rule.html"
  end

  def rules(conn, _params) do
    json conn, Cedar.Rules.ruletree
  end

  def rule_contents(conn, %{"path" => path}) do
    json conn, Cedar.Rules.contents(Enum.join path,"/")
  end

  def update_rule(conn, %{"path" => path, "contents" => contents}) do
    Enum.join(path,"/") |> Cedar.Rules.update(contents)
    json conn, %{:success => "Updated #{path}"}
  end

  def add_rule(conn, %{"rule" => rule, "path" => path}) do
    [folder,name] = Cedar.Rules.add(rule, path)
    case folder do
      nil -> json conn, %{:error => "The rule already exists" }
      _ -> json conn, %{:success => true, :folder => folder, :name => name }
    end
  end

  def changedoc(conn, _params) do
    render conn, "change.html"
  end

  def change(conn, %{"pre" => pre, "post" => post, "endpoint" => endpoint}) do
    {_status, pre}  = Poison.decode(pre)
    {_status, post} = Poison.decode(post)
    {_status, endpoint} = Poison.decode(endpoint)
    Phoenix.PubSub.broadcast Cedar.PubSub, "decision", {:change , pre: pre, post: post, endpoint: endpoint}
    json conn, %{:success => "We got your change. We'll be in touch."}
  end

  def change(conn, _params) do
    json conn, %{:error => "You really need to provide some input data Larry. Try pre, post and endpoint ;)"}
  end

  def admitdoc(conn, _params) do
    render conn, "admit.html"
  end

  def admit(conn, %{ "episode" => episode, "endpoint" => endpoint }) do
    Phoenix.PubSub.broadcast Cedar.PubSub,"decision", {:admit, episode: episode, endpoint: endpoint}
    json conn, %{:success => "We got your admission. We'll be in touch."}
  end

  def admit(conn, _params) do
    json conn, %{:error => "You really need to provide some input data Larry. Try episode and endpoint ;)"}
  end

  def dischargedoc(conn, _params) do
    render conn, "discharge.html"
  end

  def discharge(conn, %{ "episode" => episode, "endpoint" => endpoint }) do
    Phoenix.PubSub.broadcast Cedar.PubSub,"decision", {:discharge, episode: episode, endpoint: endpoint}
    json conn, %{:success => "We got your discharge. We'll be in touch."}
  end

  def discharge(conn, _params) do
    json conn, %{:error => "You really need to provide some input data Larry. Try episode and endpoint ;)"}
  end

  def transferdoc(conn, _params) do
    render conn, "transfer.html"
  end

  # ADT-A04 – Patient Registration
  def registration(conn, %{ "pre" => pre, "post" => post, "endpoint" => endpoint }) do
    Phoenix.PubSub.broadcast Cedar.PubSub,"decision", {:registration, pre: pre, post: post, endpoint: endpoint}
    json conn, %{:success => "We got your registration. We'll be in touch."}
  end

  def registration(conn, _params) do
    json conn, %{:error => "You really need to provide some input data Larry. Try pre, post and endpoint ;)"}
  end

  def registrationdoc(conn, _params) do
    render conn, "registration.html"
  end

  # ADT-A05 – patient pre-admission
  def preadmission(conn, %{ "pre" => pre, "post" => post, "endpoint" => endpoint }) do
    Phoenix.PubSub.broadcast Cedar.PubSub,"decision", {:preadmission, pre: pre, post: post, endpoint: endpoint}
    json conn, %{:success => "We got your preadmission. We'll be in touch."}
  end

  def preadmission(conn, _params) do
    json conn, %{:error => "You really need to provide some input data Larry. Try pre, post and endpoint ;)"}
  end

  def preadmissiondoc(conn, _params) do
    render conn, "preadmission.html"
  end

  # ADT-A08 – patient information update
  def update(conn, %{ "pre" => pre, "post" => post, "endpoint" => endpoint }) do
    Phoenix.PubSub.broadcast Cedar.PubSub,"decision", {:update, pre: pre, post: post, endpoint: endpoint}
    json conn, %{:success => "We got your update. We'll be in touch."}
  end

  def update(conn, _params) do
    json conn, %{:error => "You really need to provide some input data Larry. Try pre, post and endpoint ;)"}
  end

  def updatedoc(conn, _params) do
    render conn, "update.html"
  end


end
