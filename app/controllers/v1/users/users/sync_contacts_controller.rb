# frozen_string_literal: true

class V1::Users::Users::SyncContactsController < V1::Users::BaseController
  skip_before_action :ensure_profile_completion

  # POST /users/sync_contacts
  def create
    SyncContactsJob.perform_later(contacts_params, current_user.id)
    head(:ok)
  end

  private

  # Only allow a trusted parameter "white list" through.
  def contacts_params
    params.require(:numbers)
  end
end
