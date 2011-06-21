
module Dashboard
  
  module Confluence
    require 'xmlrpc/client'
    extend self

    def post content, page, user, pass, server
      confluence = XMLRPC::Client
        .new2("https://#{user}:#{pass}@#{server}/rpc/xmlrpc")
        .proxy("confluence1")
      pa = confluence.getPage("", "~#{user}", page)
      pa["content"] = "{html}#{content}{html}"
      confluence.storePage("", pa)
    end
  end
end

if __FILE__ == $0
  # test
end
