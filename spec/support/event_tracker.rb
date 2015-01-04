def allow_event_tracker(event, data)
  allow(EventTracker).to receive(:track).with(anything(), event, data)
end
