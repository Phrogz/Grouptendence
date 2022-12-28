Sequel.migration do
	change do
        add_column :event_times, :notes, String
    end
end