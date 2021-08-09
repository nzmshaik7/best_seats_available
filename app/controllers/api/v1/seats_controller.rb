class Api::V1::SeatsController < ApplicationController

    ActionController::Parameters.permit_all_parameters = true
    before_action :check_row_limit,:check_column_limit, :check_total_seats_reqeusted_limit
    
    def retrieve_best_seats
        @seats = Seat.new
        parse_best_seat_params
        set_of_best_seats = @seats.find_best_seats(@row_count, @column_count, @list_of_seats, @total_seats_requested)

        if set_of_best_seats.nil?
            render json:{ error: "No Available seats found"}
        elsif set_of_best_seats.empty?
            render json:{ error: "Seats matching request criteria not available. Please select different total_seats_requested"}
        else
            render json:{ best_seats: set_of_best_seats}
        end
    end


    protected
    def parse_best_seat_params
        @row_count = params[:venue][:layout][:rows].to_i
        @column_count = params[:venue][:layout][:columns].to_i
        @list_of_seats = params[:seats].to_h
        @total_seats_requested = params[:total_seats_requested].nil? ? 1 : params[:total_seats_requested].to_i
    end

    def check_row_limit
        if(params[:venue][:layout][:rows].to_i > Seat::MAX_ROWS_ALLOWED)
            render json: {error:"Venue row count is greater than allowed row count"}
        end
    end

    def check_column_limit
        if(params[:venue][:layout][:columns].to_i > Seat::MAX_COLUMNS_ALLOWED)
            render json: {error:"Venue column count is greater than allowed column count"}
        end
    end
    def check_total_seats_reqeusted_limit
        if(params[:total_seats_requested] && (params[:total_seats_requested].to_i > params[:venue][:layout][:rows].to_i))
            render json: {error:"total_seats_requested is greater than venue row count"}
        end
    end


end
