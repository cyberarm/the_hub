class HubDNS
  class SRV
    struct Record
      property priority, weight, port, hostname

      def initialize(@priority : Int32, @weight : Int32, @port : UInt32, @hostname : String)
      end
    end

    def initialize(@request : String)
      @records = [] of Record

      sanitize
      query
    end

    def sanitize
      @request = @request.strip

      reject! if @request.includes?(";")
      reject! unless @request.starts_with?("_")
      reject! if @request.split(" ").size > 1
      reject! unless @request.includes?(".")
    end

    # @request could not get sanitized
    def reject!
      puts "HubDNS::SRV Request: '#{@request}' was rejected because it was deemed invalid/unsafe."
      @request = ""
    end

    def query
      return unless @request.size > 0

      response = %x(dig srv #{@request} +short) # TODO: sanitize @request
      build_list(response)
    end

    def build_list(response)
      response.strip.split("\n").each do |record|
        data = record.split(" ")

        r = Record.new(data[0].to_i, data[1].to_i, data[2].to_u32, data[3])

        @records << r
      end
    end

    def best_record
      if @records.size == 1
        @records.first
      else
        @records.first # TODO: Return based on priority and weight
      end
    end
  end
end