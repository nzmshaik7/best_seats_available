# README

Problem:

* Best Available Seat:
Write a solution to return the best seat (closest to the front & middle) given a list of open seats.
Rows follow alphabetical order with "a" being the first row. Columns follow numerical order
from left to right.

* Sample Input: 
{"venue"=>{"layout"=>{"rows"=>70, "columns"=>10}},
                  "seats":{"a5"=>{"id"=>"a5", "row"=>"a", "column"=>5, "status"=>"AVAILABLE"}, "a6"=>{"id"=>"a6", "row"=>"a", "column"=>6, "status"=>"AVAILABLE"}, 
                            "a3"=>{"id"=>"a3", "row"=>"a", "column"=>3, "status"=>"AVAILABLE"}, "a2"=>{"id"=>"a2", "row"=>"a", "column"=>2, "status"=>"AVAILABLE"}, 
                            "a1"=>{"id"=>"a1", "row"=>"a", "column"=>1, "status"=>"AVAILABLE"}, "a7"=>{"id"=>"a7", "row"=>"a", "column"=>7, "status"=>"AVAILABLE"}}, 
                  "total_seats_requested" => 7}

--> venue: Includes the number of rows and columns
--> seats: Include the list of seats with row, column positions and status
--> total_seats_requested: Group of seats user requested. If user request 3 seats, we should return 3 adjacent seats from the same row.

* Sample Output: An array of the best seats.

* Process:
    --> Best seat(s) are calculated based on the summation horizontal and vertical distance of set of node(s)(seat) from pivot(the front-middle seat). The distance is assigned as a weight of that set node.
    --> The set node with minimum weight is the best seat(s) possible. 
    --> In case of multiple sets of nodes with same minimum weight, preference is given to front-left set.
* Notes:
    --> This application can process a single seat request and a group of seats request. 
    --> Weightage of '1' is given to the FRONT and MIDDLE for equal priority. We can change this weightage to prioritize one over the other. 

Technical Information:

* Ruby version - 2.2.10
* Rails version - 5.2.6
* To Run Tests: In terminal, go to the application directory and run the following:
rspec ./spec/controllers/v1/seats_controller_spec.rb

* Deployment instructions: In terminal, go to the application directory and run the following:
bundle install
rails db:create db:migrate
rails s

