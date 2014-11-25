class AddMissingIndices < ActiveRecord::Migration
  def change
        add_index :checkin_procedures, :equipment_model_id
        add_index :checkout_procedures, :equipment_model_id
        add_index :equipment_models, :category_id
        #add_index :equipment_models_requirements, [:requirement_id, :equipment_model_id]
        #add_index :equipment_models_requirements, :left_side_id
        #add_index :equipment_models_requirements, :requirement_id
        #add_index :equipment_models_requirements, [:equipment_model_id, :requirement_id]
        #add_index :equipment_models_requirements, :equipment_model_id
        #add_index :equipment_models_associated_equipment_models, [:associated_equipment_model_id, :equipment_model_id]
        #add_index :equipment_models_associated_equipment_models, :left_side_id
        #add_index :equipment_models_associated_equipment_models, :associated_equipment_model_id
        add_index :equipment_objects, :equipment_model_id
        add_index :reservations, :equipment_model_id
        add_index :reservations, :equipment_object_id
        add_index :reservations, :reserver_id
        add_index :reservations, :checkout_handler_id
        add_index :reservations, :checkin_handler_id
        #add_index :users_requirements, [:user_id, :user_id]
        #add_index :users_requirements, :left_side_id
        #add_index :users_requirements, :user_id
        #add_index :users_requirements, [:requirement_id, :requirement_id]
        #add_index :users_requirements, :requirement_id
  end
end
