defmodule ExPitch.Chord do
  alias ExPitch.Note

  chord_intervals = [
    major: [0, 4, 7],
    minor: [0, 3, 7],
    major7: [0, 4, 7, 11],
    dom7: [0, 4, 7, 10],
    minor7: [0, 3, 7, 10],
    aug: [0, 4, 8],
    dim: [0, 3, 6],
    dim7: [0, 3, 6, 9],
    halfdim: [0, 3, 6, 10]
  ]

  @spec chord(Note.t()) :: [non_neg_integer()]
  def chord(root_note), do: chord(root_note, :major)

  @spec chord(Note.t()) :: [non_neg_integer()]
  def chord(root_note, name) when is_atom(name) do
    chord(Note.note(root_note), intervals(name))
  end

  def chord(root, intervals) do
    Enum.map(intervals, &(root + &1))
  end

  @spec intervals(atom()) :: [non_neg_integer()]
  for {name, intervals} <- chord_intervals do
    def intervals(unquote(name)), do: unquote(intervals)
  end
end
