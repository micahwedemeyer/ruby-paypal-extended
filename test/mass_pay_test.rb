require 'test_helper'

class MassPayTest < Test::Unit::TestCase
  include PayPalSDK
  include PayPalSDK::Operations
  
  def setup
    @mp = MassPay.new(*mass_pay_args)
  end
  
  def test_constructor_wrong_arity
    assert_raise MassPayArityException do
      args = mass_pay_args
      args[5] = ["a", "b"] # Missing a unique identifier
      MassPay.new(*args)
    end
  end
  
  def test_call_hash
    h = @mp.send(:call_hash)
    assert_equal "MassPay", h[:method]
    
    assert_equal "USD", h[:currency_code]
    assert_equal "UserID", h[:receiver_type]
    
    assert_equal "1", h[:l_receiverid0]
    assert_equal 1.00, h[:l_amt0]
    assert_equal "a", h[:l_uniqueid0]
    
    assert_equal "3", h[:l_receiverid2]
    assert_equal 10.00, h[:l_amt2]
    assert_equal "c", h[:l_uniqueid2]
    
    assert_nil h[:l_email0]
  end
  
  def test_call_hash_email
    args = mass_pay_args
    args[0] = ["a@b.com", "a@c.com", "a@d.com"]
    args[2] = "EmailAddress"
    mp = MassPay.new(*args)
    
    h = mp.send(:call_hash)
    
    assert_equal "EmailAddress", h[:receiver_type]
    assert_equal "a@b.com", h[:l_email0]
    assert_equal "a@d.com", h[:l_email2]
    
    assert_nil h[:l_receiverid0]
  end
  
  protected
  
  def mass_pay_args
    [
      ["1", "2", "3"],
      [1.00, 5.00, 10.00],
      "UserID",
      "USD",
      nil,
      ["a", "b", "c"],
      nil
    ]
  end
  
end
