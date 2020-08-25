defmodule Boss do
  use GenServer

  def start_link(input) do
    GenServer.start_link(__MODULE__, input)
  end

  def init(input) do
    Process.flag :trap_exit, true
    IO.inspect input
    current_pid = self()

    # {args, printer} = input
    [min, max, printer] = input
    # {min, _} = Integer.parse(argv1)
    # {max, _} = Integer.parse(argv2)

    range = 5000

    split({min, max, range, current_pid, printer})

    {:ok, current_pid}
  end

  def split(input) do
    {min, max, range, current_pid, printer} = input
    processes = div(max-min, range) + 1
    # IO.puts("No of Processes = #{processes}")
    pids = []
    Enum.map(Enum.chunk_every(min..max, range), fn chunk ->
          create_workers({chunk, current_pid, printer}, pids)
        end)

    # _state_after_exec = :sys.get_state(c_pid, :infinity)
  end

  def create_workers(input, pids) do
    {:ok, pid} = Workman.start_link
    Workman.get_chunk(pid, input)
    pids = [pid | pids]
  end

  def receive_vampire(pid, result) do
    GenServer.cast(pid,{:receive_vampire, result})
  end

  def handle_cast({:receive_vampire, result}, _from) do
     {:noreply, add_vamp(result)}
  end

  def add_vamp(result) do
    {number, list} = result
    fangs = Enum.join(List.flatten(list), " ")
    IO.puts("#{number} #{fangs}")
  end
end