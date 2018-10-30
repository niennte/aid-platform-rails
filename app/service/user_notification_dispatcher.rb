class UserNotificationDispatcher
  attr_reader :errors
  attr_accessor :user_id

  def initialize(user_id)
    @errors = {}
    @system_user = User.find_by username: 'AidPlatform'
    @user_id = user_id
  end

  def report_deactivation(reactivation_date, request_title)
    message_dispatch = MessageDispatcher.new({
       sender_id: @system_user.id,
       recipient_id: @user_id,
       subject: 'Request received 5 responses!',
       body: "
Great, your request '#{request_title}' has received responses from 5 different volunteers. It is no longer public so as to give the volunteers the time to fulfill the request. If your request is not fulfilled by #{reactivation_date}, you can publish it again."
   })
    unless message_dispatch.save
      @errors = message_dispatch.errors
    end
    @errors == 0
  end

  def report_new_response(request_title)
    message_dispatch = MessageDispatcher.new({
       sender_id: @system_user.id,
       recipient_id: @user_id,
       subject: 'New response for your request!',
       body: "Your request '#{request_title}' has a new response!"
    })
    unless message_dispatch.save
      @errors = message_dispatch.errors
    end
    @errors == 0
  end

  def report_fulfilled(request, response)
    message_dispatch = MessageDispatcher.new({
       sender_id: @system_user.id,
       recipient_id: @user_id,
       subject: 'Request fulfilled!',
       body: "Request '#{request}' has has been fulfilled by response '#{response}'!"
    })
    unless message_dispatch.save
      @errors = message_dispatch.errors
    end
    @errors == 0
  end

end