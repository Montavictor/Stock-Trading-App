module Admin::TransactionsHelper
  def render_user(user)
    if user
      content_tag(:div) do
        concat content_tag(:div, user.username, class: "font-medium text-indigo-800")
        concat content_tag(:div, user.email, class: "text-xs text-gray-600")
      end
    else
      "Deleted User"
    end
  end

  def transaction_user_link(user)
    if user
      link_to 'User', admin_user_path(user),
        class: "inline-block bg-blue-500 hover:bg-blue-600 text-white text-sm font-medium px-3 py-1 rounded-md" 
    else
      content_tag(:span, 'Deleted User',
        class: "inline-block bg-gray-500 text-white text-sm font-medium px-3 py-1 rounded-md" )
    end
  end
end
