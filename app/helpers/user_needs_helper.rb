module UserNeedsHelper

  def user_needs_select
    options = UserNeed.includes(:organisation).order('user_needs.name').map do |user_need|
      ["#{user_need.name} (#{user_need.organisation.abbr}) ##{user_need.needotron_id}", user_need.id, {
        'data-as-a'      => user_need.as_a,
        'data-i-want-to' => user_need.i_want_to,
        'data-so-that'   => user_need.so_that}]
    end
    options_for_select(options)
  end

  def organisation_select(f)
    opts = { include_blank: true }
    opts[:selected] = params[:last_org_id] if params[:last_org_id]
    f.select :organisation_id,
             Organisation.order(:title).collect {|p| [ p.title, p.id ] },
             opts,
             class: 'select2 span6'
  end
end
