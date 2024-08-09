# frozen_string_literal: true

module External
  # This class is responsible for notifying our system that an edit request's status has changed.
  class EditRequestNotifier
    def self.notify(edit_request)
      new(edit_request).notify
    end

    def initialize(edit_request)
      @edit_request = edit_request
    end

    # In the real application, this method would notify an external service
    # but here we create data in the tables for simplicity.
    def notify
      EditRequest.find_by(external_id: @edit_request.id).update!(status: @edit_request.status)
    end
  end
end
