defmodule Unpreloader do
  @moduledoc """
  Unloader for clearing preloaded data for assertions
  """
  def forget(struct, field, cardinality \\ :one) do
    %{struct |
      field => %Ecto.Association.NotLoaded{
        __field__: field,
        __owner__: struct.__struct__,
        __cardinality__: cardinality
      }
    }
  end
end
