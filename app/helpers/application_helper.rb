module ApplicationHelper
  def auth_link
    if current_user
      button_to(
        "Logout",
        destroy_user_session_path,
        # data: {
        #   turbo_method: :delete,
        #   turbo_confirm: "Are you sure?"
        # },
        method: :delete,
        class: "px-4 py-2 rounded-md hover:bg-red-100 dark:hover:bg-red-500"
      )
    else
      link_to(
        "Login",
        new_user_session_path,
        class: "px-4 py-2 rounded-md hover:bg-red-100 dark:hover:bg-red-500"
      )
    end
  end
end
