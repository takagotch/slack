module SlackProxy
  class SaleController < ApplicationController
    def create
      notifier = SaleNotifier.new
      items = [params.fetch(:item_name1), params[:item_name2], params[:item_name3], params[:item_name4]].compact
      notifier.call(params.fetch(:mc_gross), params.fetch(:coupon_code), params.fetch(:payer_email), params.fetch(:first_name), params.fetch(:last_name), items)
      render nothing: true
    end
  end

  class SaleNotifier
    def call(money, code, email, name, surname, items)
      notifier = Slack::Notifier.new(
        db.fetch("webhook_url"),
	{
	  username: db.fetch("username"),
	  icon_emoji: ":panda_face",
	  attachments: [{
    	    fallback: ":panda_face:",
	    text: "+#{money}",
	    color: 'good'
	  }]
	}
      )
      if code.present?
        main_message = "#{name} #{surname} (#{email}) bought #{items.join(", ")} with the following code: #{code}"
      else
        main_message = "#{name} #{surname} (#{email}) bought #{items.join(", ")}"
      end
      notifier.ping(main_message)
    end
  end

  private 
  def db
    Rails.application.secrets.fetch(:sale_slack_data)
  end

end

