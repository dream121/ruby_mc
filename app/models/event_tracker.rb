class EventTracker
  class << self
    def track(identifier, event, data = {})
      KMTS.record(identifier, event, data)
    end
  end
end
