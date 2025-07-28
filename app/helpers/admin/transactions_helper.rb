module Admin::TransactionsHelper
  def render_user(user)
    user&.username || "Deleted User"
  end

  def transaction_user_link(user)
    if user
      link_to 'User', admin_user_path(user),
        class: "inline-block bg-blue-500 hover:bg-blue-600 text-white text-xs px-3 py-1 rounded-md transition"
    else
      content_tag(:span, 'Deleted User',
        class: "inline-block bg-gray-400 text-white text-xs px-3 py-1 rounded-md")
    end
  end
end
