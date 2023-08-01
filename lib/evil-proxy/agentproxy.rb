require 'webrick'
require 'webrick/https'
require 'webrick/httpproxy'
require 'openssl'

class EvilProxy::AgentProxyServer < EvilProxy::HTTPProxyServer

  def initialize_callbacks config
    @mitm_server = config[:MITMProxyServer]
  end

  def fire key, *args
    @mitm_server.fire key, *args, self
  end

  def perform_proxy_request(req, res, req_class, body_stream = nil)
    uri = req.request_uri
    path = uri.path.dup
    path << "?" << uri.query if uri.query
    header = setup_proxy_header(req, res)
    upstream = setup_upstream_proxy_authentication(req, res, header)
    response = nil
    
    puts "host - - - - - - - > " + uri.host.gsub('.', '\\.')
    puts "path - - - - - - - > " + path
    puts "header - - - - - - - > " + header.to_h.to_s
    
    Net::HTTP.start(uri.host.gsub('.', '\\.'), uri.port, use_ssl: true, ipaddr: uri.host, verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
        
    #request = Net::HTTP::Get.new(uri)
    
    http_req = req_class.new(path, header)
    http_req.body_stream = body_stream if body_stream
    
    http.set_debug_output $stderr
        
    
    response = http.request(http_req)
    
    # Persistent connection requirements are mysterious for me.
    # So I will close the connection in every response.
    res['proxy-connection'] = "close"
    res['connection'] = "close"

    # Convert Net::HTTP::HTTPResponse to WEBrick::HTTPResponse
    res.status = response.code.to_i
    choose_header(response, res)
    set_cookie(response, res)
    res.body = response.body
    
    end
    
    
  end

  def service req, res
    fire :before_request, req
    proxy_service req, res
    fire :before_response, req, res
  end

end
