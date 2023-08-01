#gem "sabotage", :path => "/home/aeri/Descargas/sabotage/" 


require 'sabotage'

proxy = EvilProxy::MITMProxyServer.new Port: 8089


proxy.start


