AsyncController.class_eval do
  module WithUser
    def set_current
      Current.user ||=
        if (user_id = params[:_user_id])
          ::OrmAdapter::ActiveRecord.new(::User).get(user_id)
        else
          User::Null.new
        end
      super
    end
  end
  prepend WithUser
end
