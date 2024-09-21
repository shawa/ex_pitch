defmodule ExPitch.Sequence do
  alias ExPitch.Note

  @type sequence_node :: {:division, number(), atom() | [atom()]}
  def compile(elixir_ast) do
    elixir_ast
    |> apply_operators()
    |> unwrap_do()
    |> Enum.map(&to_node/1)
  end

  def apply_operators(sequence) do
    Macro.prewalk(sequence, fn
      {:/, _metadata, args} when is_list(args) ->
        apply(Kernel, :/, args)

      ast ->
        ast
    end)
  end

  def unwrap_do(do: args) do
    args
  end

  def to_node({:->, _meta, [[division], note_or_notes]}) do
    {:division, division, List.wrap(note_or_notes)}
  end

  def find_hits(divisions, sequence_number) do
    divisions
    |> Enum.filter(fn {_, division, _notes} ->
      rem(sequence_number, trunc(division * 24)) == 0
    end)
    |> Enum.reduce([], fn {_, _, notes}, acc -> Enum.concat(notes, acc) end)
    |> Enum.map(&Note.note/1)
  end

  defmacro defsequence(_call, block) do
    divisions = compile(block)

    quote do
      def sequence(seq) do
        ExPitch.Sequence.find_hits(unquote(Macro.escape(divisions)), seq)
      end
    end
  end
end
