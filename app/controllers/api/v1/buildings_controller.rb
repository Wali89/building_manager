module Api
  module V1
    class BuildingsController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :set_client, only: [:show, :update, :client_buildings, :create]
      before_action :set_building, only: [:show, :update]

      # GET /api/v1/buildings
      # Returns a paginated list of all buildings
      def index
        @buildings = Building.includes(:client, :custom_field_values, client: :custom_fields)
                             .page(page)
                             .per(per_page)

        render json: {
          status: "success",
          buildings: format_buildings(@buildings),
          pagination: pagination_info(@buildings)
        }
      end

      # GET /api/v1/clients/:client_id/buildings/:id
      # Returns details of a specific building
      def show
        render json: {
          status: "success",
          building: format_building(@building)
        }
      end

      # POST /api/v1/clients/:client_id/buildings
      # Creates a new building for a specific client
      def create
        @building = @client.buildings.new(address: building_params[:address])
        errors = []

        Building.transaction do
          unless @building.save
            errors += @building.errors.full_messages
            raise ActiveRecord::Rollback
          end

          custom_field_errors = process_custom_fields
          if custom_field_errors.any?
            errors += custom_field_errors
            raise ActiveRecord::Rollback
          end
        end

        if errors.empty?
          render json: {
            status: "success",
            building: format_building(@building)
          }, status: :created
        else
          render json: { status: "error", errors: errors }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/clients/:client_id/buildings/:id
      # Updates an existing building
      def update
        errors = []

        Building.transaction do
          if building_params[:address] && building_params[:address] != @building.address
            if @client.buildings.where(address: building_params[:address]).where.not(id: @building.id).exists?
              errors << "Address already exists for this client"
              raise ActiveRecord::Rollback
            end
          end

          unless @building.update(address: building_params[:address])
            errors += @building.errors.full_messages
            raise ActiveRecord::Rollback
          end

          custom_field_errors = process_custom_fields
          if custom_field_errors.any?
            errors += custom_field_errors
            raise ActiveRecord::Rollback
          end
        end

        if errors.empty?
          render json: {
            status: "success",
            building: format_building(@building)
          }
        else
          render json: { status: "error", errors: errors }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/clients/:client_id/buildings
      # Returns all buildings for a specific client
      def client_buildings
        @buildings = @client.buildings.includes(:custom_field_values, client: :custom_fields)
        render json: {
          status: "success",
          buildings: format_buildings(@buildings)
        }
      end

      private

      # Sets the client based on the client_id parameter
      def set_client
        @client = Client.find(params[:client_id])
      end

      # Sets the building based on the id parameter
      def set_building
        @building = @client.buildings.find(params[:id])
      end

      # Defines the allowed parameters for building creation/update
      def building_params
        params.require(:building).permit(:address, custom_fields: {})
      end

      # Processes custom fields for a building checking to make sure that fields exist
      def process_custom_fields
        errors = []
        unknown_fields = []
        return errors unless building_params[:custom_fields]

        valid_fields = get_valid_custom_fields

        building_params[:custom_fields].each do |field_name, value|
          downcased_field_name = field_name.downcase
          custom_field = valid_fields[downcased_field_name]

          if custom_field.nil?
            unknown_fields << field_name
            next
          end

          custom_field_value = @building.custom_field_values.find_or_initialize_by(custom_field: custom_field)
          custom_field_value.value = value.is_a?(String) ? value.downcase : value

          unless custom_field_value.save
            errors << "Invalid value for #{field_name}: #{custom_field_value.errors.full_messages.join(', ')}"
          end
        end

        if unknown_fields.any?
          error_message = "Unknown custom field(s): #{unknown_fields.join(', ')}. "
          error_message += "Valid fields are: #{valid_fields.keys.join(', ')}"
          errors << error_message
        end

        errors
      end

      # Returns a hash of valid custom fields for the client
      def get_valid_custom_fields
        @client.custom_fields.index_by { |cf| cf.name.downcase }
      end

      # Returns the current page number
      def page
        params[:page] || 1
      end

      # Returns the number of items per page (max 100)
      def per_page
        [params[:per_page]&.to_i || 10, 100].min
      end

      # Returns pagination information for a collection
      def pagination_info(collection)
        {
          current_page: collection.current_page,
          next_page: collection.next_page,
          prev_page: collection.prev_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      end

      # Formats a collection of buildings for JSON output
      def format_buildings(buildings)
        buildings.map do |building|
          format_building(building)
        end
      end

      # Formats a single building for JSON output
      def format_building(building)
        client = building.client
        custom_fields = client.custom_fields.index_by(&:id)
        custom_field_values = building.custom_field_values.index_by(&:custom_field_id)

        base_info = {
          'id' => building.id.to_s,
          'client_name' => client.name,
          'address' => building.address
        }

        custom_fields.each_with_object(base_info) do |(field_id, field), result|
          value = custom_field_values[field_id]&.value || ''
          result[field.name.downcase.gsub(' ', '_')] = value.to_s
        end
      end
    end
  end
end