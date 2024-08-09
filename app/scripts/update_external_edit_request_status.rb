# frozen_string_literal: true

# This script updates the status of an ExternalEditRequest based on the provided EditRequest.id and the new status.

# Usage: rails runner update_external_edit_request_status.rb <EditRequest.id> <new_status>
# Example: rails runner scripts/update_external_edit_request_status.rb 1 approved

def update_external_edit_request_status(edit_request_id, new_status) # rubocop:disable Metrics/MethodLength
  # Fetch the EditRequest by id
  edit_request = EditRequest.find_by(id: edit_request_id)

  unless edit_request
    puts "EditRequest with ID #{edit_request_id} not found."
    return
  end

  # Fetch the associated ExternalEditRequest using the external_id from the EditRequest
  external_edit_request = ExternalEditRequest.find_by(id: edit_request.external_id)

  unless external_edit_request
    puts "ExternalEditRequest for EditRequest ID #{edit_request_id} not found."
    return
  end

  # Update the status of the ExternalEditRequest
  if ExternalEditRequest.statuses.keys.include?(new_status)
    external_edit_request.update!(status: new_status)
    puts "ExternalEditRequest with ID #{external_edit_request.id} has been updated to '#{new_status}'."
  else
    puts "Invalid status '#{new_status}'. Please provide 'approved' or 'rejected'."
  end
end

# Run the script with arguments passed from the command line
if ARGV.length != 2
  puts 'Usage: rails runner update_external_edit_request_status.rb <EditRequest.id> <new_status>'
else
  edit_request_id = ARGV[0].to_i
  new_status = ARGV[1]

  update_external_edit_request_status(edit_request_id, new_status)
end
