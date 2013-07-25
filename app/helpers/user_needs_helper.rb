module UserNeedsHelper

  def user_needs_select
    options = {}
    user_needs_group = UserNeed.includes(:organisation).order('organisations.title', 'user_needs.name').group_by(&:organisation)
    user_needs_group.each do |org, user_needs|
      options[org.title] = user_needs.map do |user_need| 
        [user_need.name, user_need.id, {
        'data-as-a'      => user_need.as_a,
        'data-i-want-to' => user_need.i_want_to,
        'data-so-that'   => user_need.so_that}]
      end
    end
    grouped_options_for_select(options)
  end
end
