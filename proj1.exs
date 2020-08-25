defmodule Proj1 do


  [first, last] = System.argv
  {first, _} = Integer.parse(first)
  {last, _} = Integer.parse(last)

    Process.flag(:trap_exit, true)

    :erlang.statistics(:runtime)
    :erlang.statistics(:wall_clock)
    {:ok, printer} = Printer.start_link([])
    {:ok, pid} = Boss.start_link([first, last, printer])
    
    Process.sleep 2_00
    _state_after_exec = :sys.get_state(pid, :infinity)


    result = Printer.get(printer)

    # Prints the Output in the required format
    Enum.map(Map.keys(result), fn(k) ->
      IO.write("#{k} ")
      Enum.map(Map.get(result,k), fn(v) ->
        IO.write("#{v} ")
      end)
      IO.puts("")
    end)


    {_, run_time} = :erlang.statistics(:runtime)
    {_, real_time} = :erlang.statistics(:wall_clock)
    ratio =
      if(real_time == 0) do
        0
      else
        run_time / real_time
      end
    IO.puts("CPU time = #{run_time} ms, Real time = #{real_time} ms, Ratio time = #{ratio}")
end