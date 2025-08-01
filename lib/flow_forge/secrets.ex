defmodule FlowForge.Secrets do
  @moduledoc """
  This module defines secrets used in the FlowForge application.
  It provides a way to securely manage sensitive information such as tokens and secrets.
  """
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        FlowForge.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:flow_forge, :token_signing_secret)
  end
end
