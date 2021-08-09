require 'rails_helper'
require 'spec_helper'

RSpec.describe Api::V1::SeatsController do

  describe "POST #retrieve_best_seats", :type => :request do
    context "Invalid Rows or Columns or Total Seats Requested" do
      it "Json response contains row count is greater than allowed row count" do
        post '/api/v1/best_seats', 
        params: {"venue"=>{"layout"=>{"rows"=>70, "columns"=>10}},
                  "seats":{"a5"=>{"id"=>"a5", "row"=>"a", "column"=>5, "status"=>"AVAILABLE"}, "a6"=>{"id"=>"a6", "row"=>"a", "column"=>6, "status"=>"AVAILABLE"}, 
                            "a3"=>{"id"=>"a3", "row"=>"a", "column"=>3, "status"=>"AVAILABLE"}, "a2"=>{"id"=>"a2", "row"=>"a", "column"=>2, "status"=>"AVAILABLE"}, 
                            "a1"=>{"id"=>"a1", "row"=>"a", "column"=>1, "status"=>"AVAILABLE"}, "a7"=>{"id"=>"a7", "row"=>"a", "column"=>7, "status"=>"AVAILABLE"}}, 
                  "total_seats_requested" => 7}
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to eq(['error'])
        expect(json_response['error']).to eq("Venue row count is greater than allowed row count")
      end

      it "Json response contains column count is greater than allowed column count" do
        post '/api/v1/best_seats', 
        params: {"venue"=>{"layout"=>{"rows"=>20, "columns"=>150}},
                  "seats":{"a5"=>{"id"=>"a5", "row"=>"a", "column"=>5, "status"=>"AVAILABLE"}, "a6"=>{"id"=>"a6", "row"=>"a", "column"=>6, "status"=>"AVAILABLE"}, 
                            "a3"=>{"id"=>"a3", "row"=>"a", "column"=>3, "status"=>"AVAILABLE"}, "a2"=>{"id"=>"a2", "row"=>"a", "column"=>2, "status"=>"AVAILABLE"}, 
                            "a1"=>{"id"=>"a1", "row"=>"a", "column"=>1, "status"=>"AVAILABLE"}, "a7"=>{"id"=>"a7", "row"=>"a", "column"=>7, "status"=>"AVAILABLE"}}, 
                  "total_seats_requested" => 7}
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to eq(['error'])
        expect(json_response['error']).to eq("Venue column count is greater than allowed column count")
      end

      it "Json response contains total seats requested is greater than venue row count" do
        post '/api/v1/best_seats', 
        params: {"venue"=>{"layout"=>{"rows"=>20, "columns"=>30}},
                  "seats":{"a5"=>{"id"=>"a5", "row"=>"a", "column"=>5, "status"=>"AVAILABLE"}, "a6"=>{"id"=>"a6", "row"=>"a", "column"=>6, "status"=>"AVAILABLE"}, 
                            "a3"=>{"id"=>"a3", "row"=>"a", "column"=>3, "status"=>"AVAILABLE"}, "a2"=>{"id"=>"a2", "row"=>"a", "column"=>2, "status"=>"AVAILABLE"}, 
                            "a1"=>{"id"=>"a1", "row"=>"a", "column"=>1, "status"=>"AVAILABLE"}, "a7"=>{"id"=>"a7", "row"=>"a", "column"=>7, "status"=>"AVAILABLE"}}, 
                  "total_seats_requested" => 50}
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to eq(['error'])
        expect(json_response['error']).to eq("total_seats_requested is greater than venue row count")
      end
    end

    context "Unavailable Seats" do
      it "Json response contains no available seats found error" do
        post '/api/v1/best_seats', 
        params: {"venue"=>{"layout"=>{"rows"=>20, "columns"=>30}},
                  "seats":{"a5"=>{"id"=>"a5", "row"=>"a", "column"=>5, "status"=>"UNAVAILABLE"}, "a6"=>{"id"=>"a6", "row"=>"a", "column"=>6, "status"=>"UNAVAILABLE"}, 
                            "a3"=>{"id"=>"a3", "row"=>"a", "column"=>3, "status"=>"UNAVAILABLE"}, "a2"=>{"id"=>"a2", "row"=>"a", "column"=>2, "status"=>"UNAVAILABLE"}, 
                            "a1"=>{"id"=>"a1", "row"=>"a", "column"=>1, "status"=>"UNAVAILABLE"}, "a7"=>{"id"=>"a7", "row"=>"a", "column"=>7, "status"=>"UNAVAILABLE"}}, 
                  "total_seats_requested" => 7}
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to eq(['error'])
        expect(json_response['error']).to eq("No Available seats found")
      end
    end

    context "Grouping seats requested" do
      it "Json response contains failure to match Seat grouping request criteria" do
        post '/api/v1/best_seats', 
        params: {"venue"=>{"layout"=>{"rows"=>20, "columns"=>30}},
                  "seats":{"a5"=>{"id"=>"a5", "row"=>"a", "column"=>5, "status"=>"AVAILABLE"}, "a6"=>{"id"=>"a6", "row"=>"a", "column"=>6, "status"=>"AVAILABLE"}, 
                            "a3"=>{"id"=>"a3", "row"=>"a", "column"=>3, "status"=>"AVAILABLE"}, "a2"=>{"id"=>"a2", "row"=>"a", "column"=>2, "status"=>"AVAILABLE"}, 
                            "a1"=>{"id"=>"a1", "row"=>"a", "column"=>1, "status"=>"AVAILABLE"}, "a7"=>{"id"=>"a7", "row"=>"a", "column"=>7, "status"=>"AVAILABLE"}}, 
                  "total_seats_requested" => 7}
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to eq(['error'])
        expect(json_response['error']).to eq("Seats matching request criteria not available. Please select different total_seats_requested")
      end

      it "Json response successfully returns group of seats" do
        post '/api/v1/best_seats', 
        params: {"venue"=>{"layout"=>{"rows"=>20, "columns"=>30}},
                  "seats":{"a5"=>{"id"=>"a5", "row"=>"a", "column"=>5, "status"=>"AVAILABLE"}, "a6"=>{"id"=>"a6", "row"=>"a", "column"=>6, "status"=>"AVAILABLE"}, 
                            "a3"=>{"id"=>"a3", "row"=>"a", "column"=>3, "status"=>"AVAILABLE"}, "a2"=>{"id"=>"a2", "row"=>"a", "column"=>2, "status"=>"AVAILABLE"}, 
                            "a1"=>{"id"=>"a1", "row"=>"a", "column"=>1, "status"=>"AVAILABLE"}, "a7"=>{"id"=>"a7", "row"=>"a", "column"=>7, "status"=>"AVAILABLE"}}, 
                  "total_seats_requested" => 3}
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to eq(['best_seats'])
        expect(json_response['best_seats']).to match_array(["a5", "a6", "a7"])
      end
    end

    context "Total Seats Requested is not present in request" do
      it "Json response contains a single seat" do
        post '/api/v1/best_seats', 
        params: {"venue"=>{"layout"=>{"rows"=>20, "columns"=>30}},
                  "seats":{"a5"=>{"id"=>"a5", "row"=>"a", "column"=>5, "status"=>"AVAILABLE"}, "a6"=>{"id"=>"a6", "row"=>"a", "column"=>6, "status"=>"AVAILABLE"}, 
                            "a3"=>{"id"=>"a3", "row"=>"a", "column"=>3, "status"=>"AVAILABLE"}, "a2"=>{"id"=>"a2", "row"=>"a", "column"=>2, "status"=>"AVAILABLE"}, 
                            "a1"=>{"id"=>"a1", "row"=>"a", "column"=>1, "status"=>"AVAILABLE"}, "a7"=>{"id"=>"a7", "row"=>"a", "column"=>7, "status"=>"AVAILABLE"}}}
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to eq(['best_seats'])
        expect(json_response['best_seats']).to match_array(["a7"])
      end
    end

    context "For a venue with 10 rows and 12 columns" do 
      it "Json response returns a6" do
        post '/api/v1/best_seats', 
        params: {"venue"=>{"layout"=>{"rows"=>10, "columns"=>12}}, 
                 "seats"=>{"a5"=>{"id"=>"a5", "row"=>"a", "column"=>5, "status"=>"AVAILABLE"}, "a4"=>{"id"=>"a4", "row"=>"a", "column"=>4, "status"=>"AVAILABLE"},
                           "a6"=>{"id"=>"a6", "row"=>"a", "column"=>6, "status"=>"AVAILABLE"}, "a3"=>{"id"=>"a3", "row"=>"a", "column"=>3, "status"=>"AVAILABLE"},
                           "a2"=>{"id"=>"a2", "row"=>"a", "column"=>2, "status"=>"AVAILABLE"}, "a1"=>{"id"=>"a1", "row"=>"a", "column"=>1, "status"=>"AVAILABLE"}, 
                           "a7"=>{"id"=>"a7", "row"=>"a", "column"=>7, "status"=>"AVAILABLE"}}}
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to eq(['best_seats'])
        expect(json_response['best_seats']).to match_array(["a6"])
      end
    end

    context "For a venue with 10 rows and 12 columns and 3 seats requested" do 
      it "Json response returns a5, a6, a7" do
        post '/api/v1/best_seats', 
        params: {"venue"=>{"layout"=>{"rows"=>10, "columns"=>12}}, 
                 "seats"=>{"a5"=>{"id"=>"a5", "row"=>"a", "column"=>5, "status"=>"AVAILABLE"}, "a4"=>{"id"=>"a4", "row"=>"a", "column"=>4, "status"=>"AVAILABLE"},
                           "a6"=>{"id"=>"a6", "row"=>"a", "column"=>6, "status"=>"AVAILABLE"}, "a3"=>{"id"=>"a3", "row"=>"a", "column"=>3, "status"=>"AVAILABLE"},
                           "a2"=>{"id"=>"a2", "row"=>"a", "column"=>2, "status"=>"AVAILABLE"}, "a1"=>{"id"=>"a1", "row"=>"a", "column"=>1, "status"=>"AVAILABLE"}, 
                           "a7"=>{"id"=>"a7", "row"=>"a", "column"=>7, "status"=>"AVAILABLE"}},
                 "total_seats_requested" => 3}
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to eq(['best_seats'])
        expect(json_response['best_seats']).to match_array(["a5", "a6", "a7"])
      end
    end

    context "For multiple set of seats with same acceptance" do 
      it "Json response prioritize front-left set" do
        post '/api/v1/best_seats', 
        params: {"venue"=>{"layout"=>{"rows"=>10, "columns"=>12}}, 
                 "seats"=>{"a1"=> {"id"=> "a1","row"=> "a","column"=> 1,"status"=> "AVAILABLE"},"b6"=> {"id"=> "b6","row"=> "b","column"=> 6,"status"=> "AVAILABLE"},
                           "b5"=> {"id"=> "b5","row"=> "b","column"=> 5,"status"=> "AVAILABLE"},"h7"=> {"id"=> "h7","row"=> "h","column"=> 7,"status"=> "AVAILABLE"},
                           "b8"=> {"id"=> "b8","row"=> "b","column"=> 8,"status"=> "AVAILABLE"},"b7"=> {"id"=> "b7","row"=> "b","column"=> 7,"status"=> "AVAILABLE"}},
                 "total_seats_requested" => 2}
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to eq(['best_seats'])
        expect(json_response['best_seats']).to match_array(["b5", "b6"])
      end
    end
  end

end


