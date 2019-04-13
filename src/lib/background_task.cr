class BackgroundTask
  getter :seconds, :storage
  def initialize(@seconds : Time::Span)
    @storage = {} of String => String
  end

  def run(&block : BackgroundTask ->)
    spawn do
      loop do
        block.call(self)
        sleep @seconds.total_seconds
      end
    end
  end
end