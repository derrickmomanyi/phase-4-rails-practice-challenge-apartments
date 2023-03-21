class LeasesController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def create
    lease = Lease.create!(lease_params)
    render json: lease, status: :created
    end

    def index
      leases = Lease.all
      render json: leases, except: [:created_at, :updated_at], status: :ok
      end
    
      def show
      lease = find_lease
      render json: lease, except: [:created_at, :updated_at], status: :ok
      end

    def destroy
    lease = find_lease
    lease.destroy
    render json: { message: 'Lease was successfully deleted' }, status: :ok
    end


    private

    def find_lease
      Lease.find(params[:id])
    end

    def lease_params
      params.permit(:apartment_id , :tenant_id, :rent)
    end

    def render_not_found_response
      render json: { error: "Leases not found" }, status: :not_found
    end

    def render_unprocessable_entity_response(invalid)
      render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end 
end
