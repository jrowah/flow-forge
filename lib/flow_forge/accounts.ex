defmodule FlowForge.Accounts do
  @moduledoc """
  This module defines the Accounts domain in the FlowForge application.
  """
  use Ash.Domain, otp_app: :flow_forge, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource FlowForge.Accounts.Token
    resource FlowForge.Accounts.User
    resource FlowForge.Accounts.ApiKey
  end
end
