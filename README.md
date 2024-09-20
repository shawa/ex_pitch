# ExPitch

This is an exploration in writing Elixir code to play some MIDI.

Originally the plan was to implement a little ear trainer (have the app play a sound, and have me play it back on the keyboard), but I ended up just implementing some of the functions from [SonicPi](https://sonic-pi.net) instead.

## Basics

This uses [midiex](https://hexdocs.pm/midiex), which is a neat wrapper around [midir](https://github.com/Boddlnagg/midir), a MIDI interface.

It boots up a `GenServer` which opens a 'connection' to your chosen MIDI channel. This `GenServer` has a `play()` callback, to which you can pass notes, which will be send as MIDI messages to the chosen channel. The `GenServer` architecture is nice, as we can just supervise multiple instruments (if I ever get that far).

## Usage

There's a bit of faff involved on first use. First you can enumerate the available ports with either `Midiex.ports/0`, or `ExPitch.port_names/0`:

```elixir
iex(5)> ExPitch.port_names()
[
  input: "IAC Driver Clock",
  input: "IAC Driver Bus 1",
  input: "IAC Driver Bus 2",
  input: "IAC Driver Bus 3",
  input: "IAC Driver Bus 5",
  input: "IAC Driver Bus 6",
  ...,
  output: "Arturia KeyStep 32",
  output: "Ableton Push 3 Live Port",
  output: "Ableton Push 3 User Port",
  output: "Ableton Push 3 External Port"
]
```

Then you can change the name in the `Producer` child spec in `application.ex` to point to your device.

With the instrument server booted, you can send it messages, and have it play notes:

```eixir
iex(6)> note(:c)
60
iex(7)> note(:c) |> play()
:ok
```

It also does chords:

```elixir
iex(9)> chord(:c, :minor) |> IO.inspect(charlists: :as_lists) 
[60, 63, 67]
~c"<?C"

# because the MIDI notes overlap w/ ASCII code points
# by default it pukes them out as charlists
```

It's also ERLANG, so we can go nuts and send messages all over the place doing all kinds of things, so that'll be fun.
