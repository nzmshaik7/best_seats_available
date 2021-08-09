class Seat < ApplicationRecord

    # row & column mapping
    Seat::ColumnMapping =-> (ip_column) {ip_column - 1}
    Seat::RowMapping= {
        'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7,
        'i' => 8, 'j' => 9, 'k' => 10, 'l' => 11, 'm' => 12, 'n' => 13, 'o' => 14, 'p' => 15,
        'q' => 16, 'r' => 17, 's' => 18, 't' => 19, 'u' => 20, 'v' => 21, 'w' => 22, 'x' => 23,
        'y' => 24, 'z' => 25, 'aa' => 26, 'ab' => 27, 'ac' => 28, 'ad' => 29, 'ae' => 30, 'af' => 31,
        'ag' => 32, 'ah' => 33, 'ai' => 34, 'aj' => 35, 'ak' => 36, 'al' => 37, 'am' => 38, 'an' => 39,
        'ao' => 40, 'ap' => 41, 'aq' => 42, 'ar' => 43, 'as' => 44, 'at' => 45, 'au' => 46, 'av' => 47,
        'aw' => 48, 'ax' => 49
    }

    # Constants
    Seat::AVAILABLE = "AVAILABLE"
    Seat::UNAVAILABLE = "UNAVAILABLE"
    Seat::WEIGHTAGE_FRONT = 1
    Seat::WEIGHTAGE_MIDDLE = 1
    Seat::MAX_ROWS_ALLOWED = 50
    Seat::MAX_COLUMNS_ALLOWED = 100

    def find_best_seats(row_count, column_count, list_of_seats, total_seats_requested)

        # filter available seats and transform to a new hash function 
        available_seats = list_of_seats.select{|k,v| v[:status] == Seat::AVAILABLE}.map{|k,v| [v[:id], [Seat::RowMapping[v[:row].downcase], Seat::ColumnMapping.call(v[:column].to_i)]]}.to_h
        return nil if available_seats.blank?

        # new hash with total seats requested
        weightage_hash = Hash.new
        weightage_hash = group_available_seats(available_seats, total_seats_requested)
        return [] if weightage_hash.empty?

        # fill in weight for each key set
        mid_column = column_count.fdiv(2).ceil
        pivot = [0, mid_column-1]

        weightage_hash.keys.each do |key|
            weight = 0
        
            weightage_hash[key][:nodes].each do |node|
                weight += (node[0] - pivot[0]).abs * Seat::WEIGHTAGE_FRONT
                weight += (node[1] - pivot[1]).abs * Seat::WEIGHTAGE_MIDDLE
            end
            weightage_hash[key][:weight] = weight
        end
        
        return weightage_hash.sort_by {|key,value| [value[:weight], value[:nodes]]}.first.first
    end

    def group_available_seats(available_seats, total_seats_requested)
        hash = Hash.new
        available_seats.keys.each do |k|
            lark = [k]
            larv = [available_seats[k]]

            (1...total_seats_requested).each do |i|
                if available_seats.has_value?([available_seats[k][0], available_seats[k][1]+i])
                    lark << available_seats.key([available_seats[k][0], available_seats[k][1]+i])
                    larv << [available_seats[k][0], available_seats[k][1]+i]
                end
            end
            if lark.size == total_seats_requested
                hash[lark] = {:nodes => larv, :weight => nil}
            end
        end
        hash
    end
    
end





