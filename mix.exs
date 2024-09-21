defmodule ExPitch.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_pitch,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ExPitch.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:midiex, "~> 0.6.3"},
      {:phoenix_pubsub, "2.1.3"}
    ]
  end
end
