require 'rubygems'
require 'eventmachine'

require_relative 'database'
@@conn = Database.new
  class EchoServer < EventMachine::Connection

    def post_init
      puts "Connection with server"
      policyInfo = '<?xml version="1.0"?>'
      policyInfo += '<cross-domain-policy>'
      policyInfo += '<allow-access-from domain="*" to-ports="8080" />'
      policyInfo += "</cross-domain-policy>\0"
      send_data policyInfo
    end

    def receive_data data

    data=data.strip if data

     send_data (@@conn.saveBuilding(data) + "\0")

    end

    def unbind
      puts "Connection is closed"
    end
  end

  EventMachine::run {

    @@conn.connect
    EventMachine::start_server 'localhost', 8080, EchoServer
  }
