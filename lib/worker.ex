defmodule  Workman do
    use GenServer

    def start_link(vamp \\ %{}) do
        GenServer.start_link(__MODULE__, vamp)
    end

    def get_chunk(pid, input) do
        GenServer.cast(pid, {:get_chunk, input})
    end

    def init(vamp) do
        {:ok, vamp}
    end

    def handle_cast({:get_chunk, input}, vamp) do
        {:noreply, compute_vampire(input,  vamp)}
    end

    def compute_vampire(input, vamp) do

        {chunk, boss_pid, printer} = input
        Enum.map(chunk, fn num ->
            if(
                Integer.mod(Kernel.length(Integer.digits(num)), 2) === 0 && Integer.mod(num, 100) !== 0
            ) do
                result_list = Enum.uniq(Enum.filter(get_fangs(num), &(!is_nil(&1))))

                if(length(result_list) > 0) do
                Printer.update(printer, [num, result_list])
                # Boss.receive_vampire(boss_pid, {num, result_list})
                end
            end
        end)
    end

  def permutations([]), do: [[]]

  def permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])

  def get_fangs(n) do
    num_list = permutations(String.codepoints(Integer.to_string(n)))

    for num <- num_list do
      str = Enum.join(num)
      {x, y} = String.split_at(str, div(String.length(str), 2))

      if String.to_integer(x) * String.to_integer(y) === n do
        Enum.sort([x, y])
      end
    end
  end
end