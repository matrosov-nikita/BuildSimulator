#!/usr/bin/env ruby
require 'webrick'
require_relative 'database'

@@conn = Database.new

$policyInfo = '<?xml version="1.0"?>'
$policyInfo += '<cross-domain-policy>'
$policyInfo += '<allow-access-from domain="*" to-ports="8080" />'
$policyInfo += "</cross-domain-policy>\0"

class MyServlet < WEBrick::HTTPServlet::AbstractServlet

  def do_GET (request, response)
    @@conn.connect


    if request.query["xml"]
    xml = request.query["xml"]
    response.status = 200
     response.content_type = "text/xml"
     response.body =  @@conn.saveBuilding(xml).to_s + "\n"
    else

      response.status = 200
      if (request.path=="/crossdomain.xml")
        puts "GO GO GO"
        puts request.path
        response.content_type = "text/xml"
        response.body = $policyInfo + "\n"
      else
    response.body = File.new(request.path[1,request.path.size-1])
      end
      end
  end
end

server = WEBrick::HTTPServer.new(:Port => 8090)

server.mount "/", MyServlet

trap("INT") {
  server.shutdown
}

server.start
