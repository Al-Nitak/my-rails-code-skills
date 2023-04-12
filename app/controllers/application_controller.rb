# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ExceptionsHandler
  include ActionView::Rendering
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i(name))
    devise_parameter_sanitizer.permit(:account_update, keys: %i(name))
  end

  def paginate(collection:, options: {}, render_options: {}, args: {})
    return render(json: collection) if params[:show_all].present?

    collection =
      collection.paginate(page: params[:page], per_page: params[:per_page])

    render(
      {
        json: collection,
        **args,
        meta:
          {
            total_entries: collection.total_entries,
            total_pages: collection.total_pages,
            next_page: collection.next_page,
            previous_page: collection.previous_page,
            current_page: (params[:page] || 1).to_i,
            per_page: (params[:per_page] || 10).to_i,
          }.merge(options),
      }.merge(render_options)
    )
  end

  def render_to_body(options)
    _render_to_body_with_renderer(options) || super
  end
end
