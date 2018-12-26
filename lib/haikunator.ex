defmodule Haikunator do
  @moduledoc """
  # Haikunator

  Generate Heroku-like memorable random names to use in your apps or anywhere else.
  """

  @adjectives Application.get_env(:haikunator, :adjectives)
  @nouns Application.get_env(:haikunator, :nouns)

  @doc """
  Generate a memorable name.

  `range` is the first parameter, and sets the range for the token (i.e. the number) from 0 to n.
  Defaults to `9999`.

  `delimiter` is the second parameter, and it's the string that joins the sections.
  Defaults to `"-"`.

  ## Examples

      # Default
      iex> Haikunator.build # => "morning-star-6817"

      # Token range
      iex> Haikunator.build(100) # => "summer-dawn-24"

      # Don't include the token
      iex> Haikunator.build(0) # => "ancient-frost"

      # Use a different delimiter
      iex> Haikunator.build(9999, ".") # => "frosty.leaf.8347"

      # No token, no delimiter
      iex> Haikunator.build(0, "") # => "twilightbreeze"
  """
  @spec build(integer, String.t) :: String.t
  def build(range \\ 9999, delimiter \\ "-", capitalize \\ false) do
    :rand.seed(:exsplus)
    token = if range > 0, do: random(range)

    [@adjectives, @nouns]
    |> Enum.map(&sample/1)
    |> Enum.concat(List.wrap(token))
    |> Enum.map(fn x -> 
      x = if is_binary(x) do String.replace(x, "-", "") end || x
      if capitalize do x |> do_capitalize() end || x
    end)
    |> Enum.join(delimiter)
  end

  @spec do_capitalize(String.t) :: String.t
  defp do_capitalize(s) when is_binary(s) do
    s |> String.capitalize()    
  end
  @spec do_capitalize(integer) :: integer
  defp do_capitalize(s), do: s

  @spec random(integer) :: integer
  defp random(range) when range > 0, do: :rand.uniform(range)

  @spec sample([any]) :: any
  defp sample(array), do: Enum.random(array)
end
