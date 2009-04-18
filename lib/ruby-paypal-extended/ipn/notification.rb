#--
# Copyright (c) 2005 Tobias Luetke
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require 'net/http'
require 'net/https'
require 'cgi'

module PayPalSDK
  module IPN
    
    # Top-level exceptin class for any IPN related exceptions.
    class IPNException < PayPalException
      
    end
    
    # Parser and handler for incoming instant payment notifications from Paypal.
    # The example shows a typical handler in a Rails application. Note that this
    # is an example, please read the Paypal API documentation for all the details
    # on creating a safe payment controller.
    #
    # Example
    #  
    #   class BackendController < ApplicationController
    #     def paypal_ipn
    #       notify = Paypal::Notification.new(request.raw_post, false)
    #       order = Order.find(notify.item_id)
    #       
    #       # Verify this IPN with Paypal.
    #       if notify.acknowledge
    #         # Paypal said this IPN is legit.
    #         begin
    #           if notify.complete? && order.total == notify.amount
    #             begin
    #               order.status = 'success'
    #               shop.ship(order)
    #               order.save!
    #             rescue => e
    #               order.status = 'failed'
    #               order.save!
    #               raise
    #             end
    #           else
    #             logger.error("We received a payment notification, but the " <<
    #                          "payment doesn't seem to be complete. Please " <<
    #                          "investigate. Transaction ID #{notify.transaction_id}.")
    #           end
    #       else
    #         # Paypal said this IPN is not correct.
    #         # ... log possible hacking attempt here ...
    #       end
    #       
    #       render :nothing => true
    #     end
    #   end
    class Notification
      CA_CERT_FILE = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "misc", "verisign.pem"))
      
      # The URL to the sandbox IPN endpoint
      SANDBOX_IPN_URL = 'https://www.sandbox.paypal.com/cgi-bin/webscr'
      PRODUCTION_IPN_URL = 'https://www.paypal.com/cgi-bin/webscr'
      
      # The IPN URL to connect to.  Defaults to production
      attr_accessor :ipn_url
      
      # The parsed Paypal IPN data parameters.
      attr_accessor :params
      
      # The raw Paypal IPN data that was received.
      attr_accessor :raw
      
      @@ca_cert_file = CA_CERT_FILE
  
      # Creates a new Paypal::Notification object. As the first argument,
      # pass the raw POST data that you've received from Paypal.
      #
      # In a Rails application this looks something like this:
      # 
      #   def paypal_ipn
      #     paypal = Paypal::Notification.new(request.raw_post)
      #     ...
      #   end
      def initialize(post, use_production = false)
        @ipn_url = use_production ? PRODUCTION_IPN_URL : SANDBOX_IPN_URL
        empty!
        parse(post)
      end
      
      # Returns the status of this transaction.
      def status
        params['payment_status']
      end
      
      # When was this payment received by the client. 
      # sometimes it can happen that we get the notification much later. 
      # One possible scenario is that our web application was down. In this case paypal tries several 
      # times an hour to inform us about the notification
      def payment_date
        Time.parse(params['payment_date'])
      end
  
      # Id of this transaction (paypal number)
      def transaction_id
        params['txn_id']
      end
  
      # What type of transaction are we dealing with? 
      def type
        params['txn_type']
      end
      
      # This is the invocie which you passed to paypal 
      def test?
        params['test_ipn'] == '1'
      end
      
      # reset the notification. 
      def empty!
        @params  = {}
        @raw     = ""      
      end
  
      # Acknowledge the transaction to paypal. This method has to be called after a new 
      # IPN arrives. Paypal will verify that all the information we received are
      # correct and will return a ok or a fail. 
      # 
      # Example:
      # 
      #   def paypal_ipn
      #     notify = PaypalNotification.new(request.raw_post)
      #
      #     if notify.acknowledge 
      #       ... process order ... if notify.complete?
      #     else
      #       ... log possible hacking attempt ...
      #     end
      #   end
      def acknowledge      
        payload = raw
        
        uri = URI.parse(self.class.ipn_url)
        request_path = "#{uri.path}?cmd=_notify-validate"
        
        request = Net::HTTP::Post.new(request_path)
        request['Content-Length'] = "#{payload.size}"
        request['User-Agent']     = "ruby-paypal-extended -- http://github.com/MicahWedemeyer/ruby-paypal-extended"
  
        http = Net::HTTP.new(uri.host, uri.port)
  
        if uri.scheme == "https"
          http.use_ssl = true
          if self.class.ca_cert_file
            http.verify_mode = OpenSSL::SSL::VERIFY_PEER
            if http.respond_to?(:enable_post_connection_check)
              # http://www.ruby-lang.org/en/news/2007/10/04/net-https-vulnerability/
              http.enable_post_connection_check = true
            end
            http.ca_file = self.class.ca_cert_file
          else
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
        end
  
        request = http.request(request, payload)
        
        raise IPNException.new("Faulty paypal result: #{request.body}") unless ["VERIFIED", "INVALID"].include?(request.body)
        
        request.body == "VERIFIED"
      end
  
      private
      
      # Take the posted data and move the relevant data into a hash
      def parse(post)
        @raw = post
        for line in post.split('&')    
          key, value = *line.scan( %r{^(\w+)\=(.*)$} ).flatten
          @params[key] = CGI.unescape(value)
        end
      end
    end
  end
end
