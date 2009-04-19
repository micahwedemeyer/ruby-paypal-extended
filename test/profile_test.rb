require 'test_helper'

class ProfileTest < Test::Unit::TestCase
  include PayPalSDK
  
  def setup
    @p = Profile.new(creds)
  end
  
  def test_constructor
    @p = Profile.new(
      creds,
      true,
      {"USE_PROXY" => true, "ADDRESS" => "foo", "PORT" => 99, "USER" => nil, "PASSWORD" => nil }
    )
    
    assert @p.use_proxy?
    assert_equal 99, @p.proxy_info["PORT"]
    assert_equal "api-3t.paypal.com", @p.endpoints["SERVER"]
  end
  
  protected
  
  def creds(opts = {})
    {
      "USER" => "sdk-three_api1.sdk.com",
      "PWD" => "QFZCWN5HZM8VBG7Q",
      "SIGNATURE" => "A.d9eRKfd1yVkRrtmMfCFLTqa6M9AyodL0SJkhYztxUi8W9pCXF6.4NI"
     }.merge(opts)
  end
end