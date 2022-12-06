Sequel.migration do
	change do
		create_table(:events) do
			String :id, primary_key: true
			String :name, null: false
			String :location
			String :description
		end

		create_table(:event_times) do
			primary_key :id
			foreign_key :event_id, :events, null: false
			DateTime :starts_at, null: false
			Integer :minutes, null:false
		end

		create_table(:confirmation_types) do
			Integer :id, primary_key:true
			String :label
			String :image
		end

		create_table(:signups) do
			foreign_key :event_time_id, :event_times, null: false
			String :name, null: false
			foreign_key :confirmation_type_id, :confirmation_types
			primary_key [:event_time_id, :name]
		end
	end
end