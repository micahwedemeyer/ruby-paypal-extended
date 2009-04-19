require 'test_helper'

class CallerTest < Test::Unit::TestCase
  include PayPalSDK
  
  def setup
    @p = Profile.new(creds)
    @c = Caller.new(@p)
  end
  
  def test_request_post_data
    post_data = @c.request_post_data(req_hash)
    assert post_data.is_a?(String)
    
    expected = "currencycode=USD&emailsubject=You+have+received+a+payment&l_amt0=5.00&l_receiverid0=12345&method=MassPay&receivertype=UserID&PWD=QFZCWN5HZM8VBG7Q&SIGNATURE=A.d9eRKfd1yVkRrtmMfCFLTqa6M9AyodL0SJkhYztxUi8W9pCXF6.4NI&USER=sdk-three_api1.sdk.com&SOURCE=ruby-paypal-extended&VERSION=56.0"
    assert_equal expected, post_data
  end
  
  protected
  
  def creds(opts = {})
    {
      "USER" => "sdk-three_api1.sdk.com",
      "PWD" => "QFZCWN5HZM8VBG7Q",
      "SIGNATURE" => "A.d9eRKfd1yVkRrtmMfCFLTqa6M9AyodL0SJkhYztxUi8W9pCXF6.4NI"
     }.merge(opts)
  end
 
  def req_hash(opts = {})
    {
      :method => "MassPay",
      :emailsubject => "You have received a payment",
      :currencycode => "USD",
      :receivertype => "UserID",
      :l_receiverid0 => "12345",
      :l_amt0 => "5.00"
    }.merge(opts)
  end
end