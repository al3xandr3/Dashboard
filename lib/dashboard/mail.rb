
module Dashboard
  
  # ==========
  # IMAP FLAGS
  # ==========
  # BEFORE <date>:  8-Aug-2002.
  # BODY <string>:
  # CC <string>:
  # FROM <string>:
  # NEW:  messages with the \Recent, but not the \Seen, flag set.
  # NOT <search-key>:
  # OR <search-key> <search-key>: "or" two search keys together.
  # ON <date>:
  # SINCE <date>:
  # SUBJECT <string>:
  # TO <string>:
  
  # ===============
  # ENVELOPE FIELDS
  # ===============
  # date:
  # subject:
  # from:     an array of Net::IMAP::Address
  # sender:   an array of Net::IMAP::Address
  # reply_to: an array of Net::IMAP::Address
  # to:       an array of Net::IMAP::Address
  # cc:       an array of Net::IMAP::Address
  # bcc:      an array of Net::IMAP::Address
  
  # ==============
  # ADDRESS FIELDS
  # ==============
  
  # name:
  # route:
  # mailbox:
  # host:

  module Mail

    require 'net/imap'
    require 'date'

    extend self
    
    def content opts={}

      opts[:port]    ||= 993
      opts[:ssl]     ||= true
      
      opts[:inbox]   ||= "Inbox"
      opts[:search]  ||= ["SINCE", "8-Aug-2007"]
      opts[:savedir] ||= "."

      imap = Net::IMAP.new(opts[:server], :port => opts[:port], :ssl => opts[:ssl])
      imap.login(opts[:user], opts[:pass])
      imap.select(opts[:inbox])
      imap.search(opts[:search]).each do |uid|
        body = imap.fetch(uid,"BODY[TEXT]")[0].attr["BODY[TEXT]"]
        body.gsub!("=3D", "=") # cleans stupid escaping params
        date = Date.parse(imap.fetch(uid, ["ENVELOPE","UID","BODY"])[0].attr["ENVELOPE"].date)
        File.open(opts[:savedir] + "#{opts[:search][1]}-#{date.to_s}.html",'wb+') do |f|
          f.write(body)
        end                
      end  
    end
    
    def download opts={}
      
      opts[:port]    ||= 993
      opts[:ssl]     ||= true

      opts[:inbox] = opts[:inbox]     || "Inbox"
      opts[:search] = opts[:search]   || ["SINCE", "8-Aug-2007"]
      opts[:attach] = opts[:attach]   || ["CSV"]
      opts[:savedir] = opts[:savedir] || "."
      
      imap = Net::IMAP.new(opts[:server], :port => opts[:port], :ssl => opts[:ssl])
      imap.login(opts[:user], opts[:pass])
      imap.select(opts[:inbox])
      imap.search(opts[:search]).each do |uid|
        msg = imap.fetch(uid, ["ENVELOPE","UID","BODY"])[0]
        body = msg.attr["BODY"]
        date = Date.parse(msg.attr["ENVELOPE"].date)
        i = 1
        while body.parts[i] != nil
          type = body.parts[i].subtype
          encoding = body.parts[i].encoding
          name = body.parts[i].param["NAME"] || date.to_s
          i+=1
          attachment = imap.fetch(uid, "BODY[#{i}]")[0].attr["BODY[#{i}]"]
          #pp "#{name}, #{type}, #{encoding}"
          if opts[:attach].include? type and not attachment.nil?
            File.open(opts[:savedir] + name,'wb+') do |f|
              if encoding == "BASE64"
                f.write(attachment.unpack('m')[0])
              else
                f.write(attachment)
              end          
            end
          end
        end  
      end
    end
    
    def archive opts={:inbox => "Inbox", :search => ["SINCE", "8-Aug-2007"]}  
      
      opts[:port]    ||= 993
      opts[:ssl]     ||= true

      opts[:inbox] = opts[:inbox]     || "Inbox"
      opts[:search] = opts[:search]   || ["SINCE", "8-Aug-2007"]
      opts[:archive] = opts[:archive] || "Archive"
      
      imap = Net::IMAP.new(opts[:server], :port => opts[:port], :ssl => opts[:ssl])
      imap.login(opts[:user], opts[:pass])
      imap.select(opts[:inbox])    
      imap.search(opts[:search]).each do |uid|
        imap.copy(uid, "Archive")
        imap.store(uid, "+FLAGS", [:Deleted])     
      end
      imap.expunge # do it
    end
    
  end  
end

if __FILE__ == $0
  #testing code 
end
  
