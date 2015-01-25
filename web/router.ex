defmodule Cedar.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/", Cedar do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index, as: :pages
    get "/rules/", EditorController, :editor
    get "/api/v0.1/", Api01Controller, :index
  end

  scope "/api/v0.1", Cedar do
     pipe_through :api

    get "/rules/check", Api01Controller, :valid_ruledoc
    post "/rules/check", Api01Controller, :valid_rule

    get "/rules/", Api01Controller, :rules
    get "/rules/contents/*path", Api01Controller, :rule_contents
    post "/rules/contents/*path", Api01Controller, :update_rule

    post "/rules/", Api01Controller, :add_rule


    get "/change/", Api01Controller, :changedoc
    post "/change/", Api01Controller, :change

    # Begin HL7 ADT event types

    # ADT-A01 – patient admit
    get "/admit/", Api01Controller, :admitdoc
    post "/admit/", Api01Controller, :admit

    # ADT-A02 – patient transfer
    get "/transfer/", Api01Controller, :transferdoc
    post "/transfer/", Api01Controller, :transfer

    # ADT-A03 – patient discharge
    get "/discharge/", Api01Controller, :dischargedoc
    post "/discharge/", Api01Controller, :discharge

    # ADT-A04 – patient registration
    get "/registration/", Api01Controller, :registrationdoc
    post "/registration/", Api01Controller, :registration

    # ADT-A05 – patient pre-admission
    get "/preadmission/", Api01Controller, :preadmissiondoc
    post "/preadmission/", Api01Controller, :preadmission

    # ADT-A08 – patient information update
    get "/update/", Api01Controller, :updatedoc
    post "/update/", Api01Controller, :update

  end
end
