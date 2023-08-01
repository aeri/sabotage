<p align="center">
  
![RECUP_sabotage-ranvXIIIwhite](https://github.com/aeri/sabotage/assets/23065231/e9b04b60-309c-4b2b-a3f3-41a8721d5c97) 

</p>

---

Sabotage is an HTTPS proxy to bypass censorship by filtering the SNI (Server Name Indication). This proxy is based on [evil-proxy](https://github.com/bbtfr/evil-proxy) which uses [Webrick](https://github.com/ruby/webrick) as HTTP Toolkit.

This proxy bypasses some of the most sophisticated SNI filtering systems by modifying the extension of the ClientHello message sent in all HTTPS requests. There is no change in either the TCP/IP host address or HTTP Host header value.

Specifically, the character ```\``` is added at the point separating the domain name with the top-level domain. This simple and subtle change goes unnoticed by SNI filters and usually works well with many Internet servers and CDNs (depending on the circumstances and configuration).
