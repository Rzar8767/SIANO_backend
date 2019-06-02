defmodule Siano.BudgetToken do
  @settings Hashids.new([
    salt: "cebula",
    min_len: 4,
    ])

  def encode(budget_id, seed) do
    Hashids.encode(@settings, [budget_id, seed])
  end

  def decode(data) do
    Hashids.decode(@settings, data)
  end

end
