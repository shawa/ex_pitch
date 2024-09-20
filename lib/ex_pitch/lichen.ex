defmodule ExPitch.Lichen do
  use ExPitch

  def chords do
    [
      chord(:D),
      chord(:Fs, :minor),
      chord(:Fs),
      chord(:B, :minor)
    ]
  end
end
