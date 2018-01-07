defmodule ExPesel.Pesel do
  @moduledoc false

  # wages for calculating PESEL checksum
  @w [9, 7, 3, 1, 9, 7, 3, 1, 9, 7]

  # longest human lifespan in years
  @years 123

  # PESEL is valid
  # when checksum for 10 first digits is equal to 11 digit
  # when first 6 digits gives proper date
  # when first 6 digits gives date until today, PESEL for future is invalid
  @spec valid?(String.t()) :: boolean()
  def valid?(pesel) when is_binary(pesel) do
    checksum?(to_list(pesel), @w, 0)
    and valid_birthdate?(birthdate(pesel))
  end

  defp checksum?([crc], [], acc),         do: crc == rem(acc, 10)
  defp checksum?([x | r], [w | rw], acc), do: checksum?(r, rw, x * w + acc)
  defp checksum?(_, _, _),                do: false

  defp valid_birthdate?(date),  do: valid_date?(date) and till_today?(date)
  defp valid_date?(date),       do: :calendar.valid_date(date)
  defp till_today?(date),       do: date <= today()
  defp today,                   do: extract_date(:calendar.universal_time)
  defp extract_date({date, _}), do: date

  # PESEL is valid and was issued for specified birthdate
  @spec valid_with?(String.t(), {1800..2299, 1..12, 1..3}) :: boolean()
  def valid_with?(pesel, birthday)
  when is_binary(pesel) and is_tuple(birthday) do
    valid?(pesel) and birthdate(pesel) == birthday
  end

  # PESEL is valid and was issued for specified sex
  @spec valid_with?(String.t(), :male|:female) :: boolean()
  def valid_with?(pesel, sex)
  when is_binary(pesel) and is_atom(sex) do
    valid?(pesel) and sex(pesel) == sex
  end

  # Date of birth is encoded in first 6 digits as yymmdd
  # in month mm there is encoded century as:
  # for 1800-1899 we got addition of 80 to mm
  # for 1900-1999 we got addition of  0 to mm
  # for 2000-2099 we got addition of 20 to mm
  # for 2100-2199 we got addition of 40 to mm
  # for 2200-2299 we got addition of 60 to mm
  @spec birthdate(String.t()) :: {1800..2299, 1..12, 1..3}
  def birthdate(pesel), do: do_birthdate(to_list(pesel))

  # sorry for that but in elixir there is no multiguards
  defp do_birthdate([y1, y2, m1, m2, d1, d2 | _])
  when m1 < 2, do: date({19, y1, y2}, {m1, m2}, {d1, d2})

  defp do_birthdate([y1, y2, m1, m2, d1, d2 | _])
  when m1 < 4, do: date({20, y1, y2}, {m1 - 2, m2}, {d1, d2})

  defp do_birthdate([y1, y2, m1, m2, d1, d2 | _])
  when m1 < 6, do: date({21, y1, y2}, {m1 - 4, m2}, {d1, d2})

  defp do_birthdate([y1, y2, m1, m2, d1, d2 | _])
  when m1 < 8, do: date({22, y1, y2}, {m1 - 6, m2}, {d1, d2})

  defp do_birthdate([y1, y2, m1, m2, d1, d2 | _])
  when m1 < 10, do: date({18, y1, y2}, {m1 - 8, m2}, {d1, d2})

  defp date(as_year, as_month, as_day) do
    {year(as_year), month(as_month), day(as_day)}
  end

  defp day({d1, d2}),           do: d1 * 10 + d2
  defp month({m1, m2}),         do: m1 * 10 + m2
  defp year({century, y1, y2}), do: century * 100 + y1 * 10 + y2

  # Sex is encoded with 10 digit
  # odd for male
  # even for female
  @spec sex(String.t()) :: :male | :female
  def sex(pesel) when is_binary(pesel), do: do_sex(to_list(pesel))

  defp do_sex([_, _, _, _, _, _, _, _, _, s | _]) when rem(s, 2) == 1, do: :male
  defp do_sex(_), do: :female

  # PESEL is zombie if
  # date of birth is 123 years before today
  @spec zombie?(String.t()) :: boolean()
  def zombie?(pesel) when is_binary(pesel), do: is_zombie?(pesel)

  defp is_zombie?(pesel), do: birthdate(pesel) < years_before(today(), @years)
  defp years_before({year, month, day}, dist), do: {year - dist, month, day}

  # Transpose from string to list
  defp to_list(pesel) do
    pesel
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
