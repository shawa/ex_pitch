defmodule ExPitch.Note do
  @type t() :: atom() | non_neg_integer() | nonempty_binary()

  notes = %{
    "A" => 57,
    "B" => 59,
    "C" => 60,
    "D" => 62,
    "E" => 64,
    "F" => 65,
    "G" => 67
  }

  note_letters = Map.keys(notes)
  flat_sharps = ["b", "", "s"]
  octaves = 1..12

  default_octave = 4

  resolve_note = fn note, octave, flat_sharp ->
    octave_offset = 12 * (octave - default_octave)

    flat_sharp_offset =
      case flat_sharp do
        "b" -> -1
        "" -> 0
        "s" -> 1
      end

    midi_code = Map.fetch!(notes, note)
    midi_code + octave_offset + flat_sharp_offset
  end

  @spec note(atom() | nonempty_binary() | integer()) :: integer()
  for octave <- octaves,
      note <- note_letters,
      flat_sharp <- flat_sharps,
      note_reference = "#{note}#{flat_sharp}#{octave}",
      note_reference_atom = String.to_atom(note_reference),
      note_reference_lower = String.downcase(note_reference),
      note_reference_lower_atom = String.to_atom(note_reference_lower) do
    def note(unquote(note_reference)) do
      unquote(resolve_note.(note, octave, flat_sharp))
    end

    def note(unquote(note_reference_atom)) do
      unquote(resolve_note.(note, octave, flat_sharp))
    end

    def note(unquote(note_reference_lower)) do
      unquote(resolve_note.(note, octave, flat_sharp))
    end

    def note(unquote(note_reference_lower_atom)) do
      unquote(resolve_note.(note, octave, flat_sharp))
    end
  end

  for note <- note_letters,
      flat_sharp <- flat_sharps,
      note_reference = "#{note}#{flat_sharp}",
      note_reference_atom = String.to_atom(note_reference),
      note_reference_lower = String.downcase(note_reference),
      note_reference_lower_atom = String.to_atom(note_reference_lower) do
    def note(unquote(note_reference)) do
      unquote(resolve_note.(note, default_octave, flat_sharp))
    end

    def note(unquote(note_reference_atom)) do
      unquote(resolve_note.(note, default_octave, flat_sharp))
    end

    def note(unquote(note_reference_lower)) do
      unquote(resolve_note.(note, default_octave, flat_sharp))
    end

    def note(unquote(note_reference_lower_atom)) do
      unquote(resolve_note.(note, default_octave, flat_sharp))
    end
  end

  def note(n) when is_integer(n), do: n

  drums_808 =
    ~w[ kick rim snare clap
        conga_low conga_mid hat_closed conga_hi
        tom_low tom_mid hat_open tom_hi
        maracas cymbal cow claves
      ]a

  for {name, index} <- Enum.with_index(drums_808) do
    # MIDI Drums usually start on C1
    @spec drum(atom()) :: 36..51
    def note(unquote(name)), do: unquote(index + 36)
    def drum(unquote(name)), do: unquote(index + 36)
  end
end
