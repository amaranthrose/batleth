require Amnesia
use Amnesia

defdatabase Database do
    deftable Wpis, [ :status, :pr, :timestamp], type: :ordered_set, index: [:timestamp] do
        @type t :: %Wpis{timestamp: non_neg_integer, status: non_neg_integer, pr: non_neg_integer}
        
        @doc """
            Returns a list of records from timestamp to timestamp.
            """
        def get(tmp2, tmp3) do
            :not_implemented
        end


        @doc """
            Adds and saves a Wpis in the database
            """
        def add(self) do
            :not_implemented
        end
    end
end
