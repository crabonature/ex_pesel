defmodule ExPesel do
  @moduledoc """
  Library for PESEL number.

  * `ExPesel.valid?/1` - you can check if PESEL number is valid
  * `ExPesel.valid_with?/2` - you can check if PESEL number is valid with additional check about sex or birthdate
  * `ExPesel.birthdate/1` - you can obtain date of birth from PESEL number
  * `ExPesel.sex/1` - you can obtain sex from the PESEL number
  * `ExPesel.zombie?/1` - you can obtain is PESEL number is a zombie (more than 123 years before today)

  More about PESEL number:
  * [Wikipedia EN](https://en.wikipedia.org/wiki/PESEL)
  * [Wikipedia PL](https://pl.wikipedia.org/wiki/PESEL)
  * [obywatel.gov.pl](https://obywatel.gov.pl/dokumenty-i-dane-osobowe/czym-jest-numer-pesel)
  """

  alias ExPesel.Pesel

  @doc """
  Is PESEL number valid?

  PESEL is valid when:
    * length of it is 11
    * last digit is proper checksum for first ten digits
    * date of birt from first 6 digits are proper
    * date of birth is until today.

  For example:
      iex> ExPesel.valid?("44051401458")
      true

      iex> ExPesel.valid?("90720312611")
      false

      iex> ExPesel.valid?("90520308014")
      false

      iex> ExPesel.valid?("44051401459")
      false

      iex> ExPesel.valid?("00000000000")
      false

      iex> ExPesel.valid?("234555")
      false

      iex> ExPesel.valid?("23455532312131123123")
      false

      iex> ExPesel.valid?("some really bad data")
      false
  """
  @spec valid?(String.t()) :: boolean()
  defdelegate valid?(pesel), to: Pesel

  @doc """
  Is PESEL valid and additionaly:
  * belongs to male?
  * or belongs to female?
  * or date of birth extracted from PESEL is equal birthdate?

  For example:

      iex> ExPesel.valid_with?("44051401458", :male)
      true

      iex> ExPesel.valid_with?("88122302080", :male)
      false

      iex> ExPesel.valid_with?("44051401458", :female)
      false

      iex> ExPesel.valid_with?("88122302080", :female)
      true

      iex> ExPesel.valid_with?("44051401458", {1944, 5, 14})
      true

      iex> ExPesel.valid_with?("44051401458", {1944, 6, 13})
      false

      iex> ExPesel.valid_with?("some really bad data", {1944, 6, 13})
      false
  """
  def valid_with?(pesel, sex_or_birthday)

  # sorry have to do by def because there is no defdelegate with atoms
  @spec valid_with?(String.t(), :male) :: boolean()
  def valid_with?(pesel, :male), do: Pesel.valid_with?(pesel, :male)

  @spec valid_with?(String.t(), :female) :: boolean()
  def valid_with?(pesel, :female), do: Pesel.valid_with?(pesel, :female)

  @spec valid_with?(String.t(), {1800..2299, 1..12, 1..31}) :: boolean()
  defdelegate valid_with?(pesel, birthdate), to: Pesel

  @doc """
  Returns date of birth extracted from PESEL.

  Date of birth is encoded by first 6 digits as: `yymmdd`

  Century is encoded in `mm` part of it:
  * 1800 - 1899 there is addition of 80 to `mm`
  * 1900 - 1999 there is addition of  0 to `mm`
  * 2000 - 2099 there is addition of 20 to `mm`
  * 2100 - 2199 there is addition of 40 to `mm`
  * 2200 - 2299 there is addition of 50 to `mm`

  For example:
      iex> ExPesel.birthdate("01920300359")
      {1801, 12, 3}

      iex> ExPesel.birthdate("44051401459")
      {1944, 5, 14}

      iex> ExPesel.birthdate("10320305853")
      {2010, 12, 3}

      iex> ExPesel.birthdate("90520308014")
      {2190, 12, 3}

      iex> ExPesel.birthdate("90720312611")
      {2290, 12, 3}

      iex> ExPesel.birthdate("some really bad input")
      :unknown
  """
  @spec birthdate(String.t()) :: {1800..2299, 1..12, 1..31} | :unknown
  defdelegate birthdate(pesel), to: Pesel

  @doc """
  Returns sex extracted from PESEL.

  Sex is encoded by digit at 10 position:
  * even number for female
  * odd number for male

  For example:
      iex> ExPesel.sex("44051401459")
      :male

      iex> ExPesel.sex("88122302080")
      :female

      iex> ExPesel.sex("some bad input")
      :unknown
  """
  @spec sex(String.t()) :: :male | :female | :unknown
  defdelegate sex(pesel), to: Pesel

  @doc """
  Is PESEL number a zombie?

  We got zombie PESEL when it has date of birth 123 years before today.

  For example:
      iex> ExPesel.zombie?("01920300359")
      true

      iex> ExPesel.zombie?("88122302080")
      false

      iex> ExPesel.zombie?("I'm a zombie man!")
      false
  """
  @spec zombie?(String.t()) :: boolean()
  defdelegate zombie?(pesel), to: Pesel
end
