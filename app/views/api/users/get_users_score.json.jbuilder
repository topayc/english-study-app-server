json.status @status
json.msg @msg

if @status == true
  json.data do |json|
    json.score @user_info do |w|
      json.array! w 
    end
    json.mine @mine
    json.current_time @current_time
    json.finish_time  @finish_time
    json.time_diff    @time_diff
  end
end
