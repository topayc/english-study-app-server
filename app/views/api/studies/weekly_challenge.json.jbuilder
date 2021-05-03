json.status @status
json.msg  @msg

if @status == true
  json.high_score @high_score
  json.test @test
end
