module PagesHelper

  def host_form_action
    remove_keys = %w( action controller id host )
    form_params = params.clone
    remove_keys.map { |key| form_params.delete(key) }
    form_params.to_query
  end
end
