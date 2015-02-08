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
    get "/editor/rules", EditorController, :editor
    get "/editor/variables", EditorController, :variables
    get "/status", StatusController, :index

    get "/status/:year", StatusController, :year
    get "/status/:year/:month", StatusController, :month
    get "/status/:year/:month/:day", StatusController, :day

    get "/api/v0.1/", Api01Controller, :index
  end

  # API Docs
  scope "/api/v0.1", Cedar do
    pipe_through :browser

    get "/rules/check", Api01Controller, :valid_ruledoc
    get "/rules/", Api01Controller, :rules
    get "/change/", Api01Controller, :changedoc
    get "/admit/", Api01Controller, :admitdoc
    get "/transfer/", Api01Controller, :transferdoc
    get "/discharge/", Api01Controller, :dischargedoc
    get "/registration/", Api01Controller, :registrationdoc
    get "/preadmission/", Api01Controller, :preadmissiondoc
    get "/update/", Api01Controller, :updatedoc

  end

  # API calls
  scope "/api/v0.1", Cedar do
     pipe_through :api

    post "/rules/check", Api01Controller, :valid_rule

    get "/rules/contents/*path", Api01Controller, :rule_contents
    post "/rules/contents/*path", Api01Controller, :update_rule

    post "/rules/", Api01Controller, :add_rule
    post "/change/", Api01Controller, :change

    # Begin HL7 ADT event types

    # ADT-A01 – patient admit
    post "/admit/", Api01Controller, :admit

    # ADT-A02 – patient transfer
    post "/transfer/", Api01Controller, :transfer

    # ADT-A03 – patient discharge
    post "/discharge/", Api01Controller, :discharge

    # ADT-A04 – patient registration
    post "/registration/", Api01Controller, :registration

    # ADT-A05 – patient pre-admission
    post "/preadmission/", Api01Controller, :preadmission

    # ADT-A08 – patient information update
    post "/update/", Api01Controller, :update

  end
end
