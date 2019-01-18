# Implements cookie based flash messages

class Flash
  def initialize(context : HTTP::Server::Context)
    @context = context

    @flash_cookie = "hub_flash"
    @now  = {} of String => String
    @next = {} of String => String

    @keep = false

    cookie = context.request.cookies[@flash_cookie]?
    begin
      return unless cookie

      data = JSON.parse(cookie.value)
      data.as_h.each do |key, value|
        @now[key.to_s] = value.as_s
      end
    rescue JSON::ParseException # Nothing to load, most likely.
    end
  end

  def []=(key : Symbol, value : String)
    @next[key.to_s] = value
  end

  def []=(key : String, value : String)
    @next[key] = value
  end

  def [](key : String)
    @now[key]
  end

  def [](key : Symbol)
    @now[key.to_s]
  end

  def []?(key : String)
    @now[key]?
  end

  def []?(key : Symbol)
    @now[key.to_s]?
  end

  def pending?
    @now.size > 0
  end

  # Don't destroy cookies this round
  def keep!
    @keep = true
  end

  def keep?
    @keep
  end

  # Write changes.
  # NOTE to self: don't name methods .finalize, Crystal's GC started complaining. :D
  def complete
    return if @keep

    # Overwrite previous cookie if anything to flash
    if @next.size > 0
      cookie = HTTP::Cookie.new(@flash_cookie, @next.to_json)
      cookie.http_only = true

      @context.response.cookies[@flash_cookie] = cookie
    else
      # Delete cookie if nothing to flash
      @context.response.cookies[@flash_cookie] = ""
    end
  end
end

class HTTP::Server::Context
  property! flash : Flash

  # inject flash method into context (env)
  def flash
    @flash ||= Flash.new(self)
    @flash.not_nil!
  end
end

after_all do |env|
  env.flash.complete # Write cookie after everything
end