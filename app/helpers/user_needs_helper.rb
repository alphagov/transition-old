module UserNeedsHelper

  def user_needs_select
    options = {}
    user_needs_group = UserNeed.joins(:organisation).order('organisations.title', 'user_needs.name').
      group_by {|user_need| user_need.organisation}
    user_needs_group.keys.each do |org|
      options[org.title] = user_needs_group[org].map {|user_need| [user_need.name, user_need.id]}
    end
    grouped_options_for_select(options)
  end
end
