class MessageDispatcher
  attr_accessor :sender_id, :recipient_id, :subject, :body, :message, :dispatch, :errors

  def initialize(params = {})
    @recipient_id = params[:recipient_id]
    @subject = params[:subject]
    @body = params[:body]
    @errors = {}
  end

  def save
    # Save Message and MessageDispatch in a transaction
    ActiveRecord::Base.transaction do
      @message = Message.new(user_id: sender_id, subject: subject, body: body)
      if @message.save
        @dispatch = MessageDispatch.new(message_id: @message.id, user_id: recipient_id)
        unless @dispatch.save
          @errors[:recipient_id] = @dispatch.errors[:user]
        end
      else
        @errors = @message.errors.to_h
        return false
      end
    end
    @errors.length == 0
  end

  def public
    @dispatch.extend(MessageDispatchView).public
  end

  def recursive
    @dispatch.extend(MessageDispatchView).recursive
  end

  def editable
    {
      recipient_id: recipient_id,
      subject: subject,
      body: body
    }
  end
end
