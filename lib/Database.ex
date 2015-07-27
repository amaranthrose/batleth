require Amnesia
use Amnesia

defdatabase Database do
    deftable Wpis, [ :timestamp, :status, :pr, :last_st_change ], type: :ordered_set do
        @type t :: %Wpis{timestamp: non_neg_integer, status: non_neg_integer, last_st_change: non_neg_integer, pr: non_neg_integer}
        
        @doc """
            Returns a list of records from timestamp to timestamp.
            """
        def get(tmp2, tmp3) do
            Amnesia.transaction do
               r = where timestamp > tmp2 and timestamp < tmp3
               Amnesia.Selection.values(r)
            end
        end
   
        @doc """
             Returns the timestamp of the last record from the database
             """

        def getLast() do
            Amnesia.transaction do
                Wpis.last(true)
            end
        end


        @doc """
             Parses percentage and status to a struct Wpis, adding the current timestamp (in sec)
             """

        def parse_wpis(percentage, st, tmp \\ :timestamp) do
		tms = Time.timestamp
		case getLast() do
			a when is_integer a ->
	    			a = Wpis.read(a)
				last_timestamp = 0

	   			if a.status == st do
					last_timestamp = a.last_st_change
	    			else
					last_timestamp = tms
				end
			nil -> last_timestamp = tms
	   	end
		case tmp do
			:timestamp -> tms = tms
			_ -> tms = tms-3
		end 
            %Wpis{ timestamp: tms, status: st, pr: percentage, last_st_change: last_timestamp}
        end
            
        @doc """
            Adds and saves a Wpis in the database
            """
        def add(self) do
            Amnesia.transaction do
                write(self)
            end
        end
    end
end
