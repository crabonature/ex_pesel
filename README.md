# ExPesel

**Elixir library for PESEL number.**

  * `ExPesel.valid?/1` - you can check if PESEL number is valid
  * `ExPesel.valid_with?/2` - you can check if PESEL number is valid with additional check about sex or date of birth
  * `ExPesel.birthdate/1` - you can obtain date of birth from PESEL number
  * `ExPesel.sex/1` - you can obtain sex from the PESEL number
  * `ExPesel.zombie?/1` - you can check is PESEL number is a zombie (more than 123 years before today)

  More about PESEL number:
  * [Wikipedia EN](https://en.wikipedia.org/wiki/PESEL)
  * [Wikipedia PL](https://pl.wikipedia.org/wiki/PESEL)
  * [obywatel.gov.pl](https://obywatel.gov.pl/dokumenty-i-dane-osobowe/czym-jest-numer-pesel)

## Usage

```elixir
iex> ExPesel.valid?("44051401458")
true

iex> ExPesel.valid?("90720312611")
false

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

iex> ExPesel.birthdate("10320305853")
{2010, 12, 3}

iex> ExPesel.sex("88122302080")
:female

iex> ExPesel.zombie?("01920300359")
true
```

## Installation

Package can be installed by adding `ex_pesel`
to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_pesel, "~> 0.2.0"}
  ]
end
```

## Documentation

Docs can be found at [https://hexdocs.pm/ex_pesel](https://hexdocs.pm/ex_pesel).

## License

Source code of ex_pesel is released under the Apache 2.0 license, see the [LICENSE](LICENSE) file.
