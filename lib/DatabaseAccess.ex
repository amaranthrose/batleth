defmodule DatabaseAccess do
        use Database
	@doc """
		Starts a databaseaccess. Takes two parameters - pids of the reader and the clock.
		If succeeded, returns a tuple {:ok, pid}  
	"""
	def start_link(pid_c) do
		Task.start_link(fn() -> loop(pid_c) end)
	end
      
	defp loop(pid_c) do
		receive do
			{atom, t, caller} ->
				case atom do
					:get -> 
						case t do
							:last_timestamp -> 
                            					#unless caller == pid_c do
                                				#send caller, {:error}

                            					case Wpis.getLast() do
                                					nil -> send caller, {:ok, 0}
                                					l -> send caller, {:ok, l }
                                					_ -> send caller, { :error, :db }
			                        		end
							_ -> :not_implemented
						end
                        		:add ->
						case t do
							nil ->
								IO.puts ":nil"
								Wpis.parse_wpis(nil, nil, nil) |> Wpis.add
								send caller, {:ok}
							%{status: stat, pr: per} -> 
                            					#unless caller == pid_c do
                            					#    send caller, {:error}
                            					Wpis.parse_wpis(per, stat) |> Wpis.add
                            					send caller, {:ok}
                            
							_ -> :not_implemented
						end
					_ -> :not_implemented
				end
			_ -> :not_implemented
                loop(pid_c)
		end
	end
end 
