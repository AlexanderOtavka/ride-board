require 'aws-sdk-sns'

module Notifier
  class SmsNotifier < Base
    def initialize(real_messages)
      super(real_messages)
      if real_messages
        # Pulls in info from environment automatically
        @sns = Aws::SNS::Client.new#(credentials: )
      end

      @logger = Rails.logger
      @message_attributes = {
        "AWS.SNS.SMS.SenderID" => {
          data_type: "String",
          # Must be 1-11 alphanumeric
          string_value: "Rideboard",
        },
        "AWS.SNS.SMS.MaxPrice" => {
          data_type: "String",
          # Maximum we're willing to pay for a text in USD
          # Although this should not be how much we actually pay in general
          string_value: "0.10",
        },
        "AWS.SNS.SMS.SMSType" => {
          data_type: "String",
          # We care about these messages being delivered, despite promotional
          # being potentially a bit cheaper
          string_value: "Transactional",
        }
      }
    end

    # user: a user model
    # message: string
    def log_message(user, message)
      phone_str = _get_full_phone_number(user)
      _build_and_log_aws_message(phone_str, message)
      @logger.info "Sending text '#{message}' to: #{phone_str}"
    end

    def real_message(user, message)
      phone_str = _get_full_phone_number(user)
      msg = _build_and_log_aws_message(phone_str, message)
      begin
        @sns.publish(msg)
      rescue Aws::SNS::Errors::AuthorizationErrorException
        raise Errors::AuthError
      rescue Aws::Errors::MissingCredentialsError
        raise Errors::AuthError
      rescue Aws::SNS::Errors::ConcurrentAccessException
        raise Errors::ExternalServiceError
      rescue Aws::SNS::Errors::EndpointDisabledException
        raise Errors::MalformedRequestException
      rescue Aws::SNS::Errors::InternalErrorException
        raise Errors::ExternalServiceError
      rescue Aws::SNS::Errors::NotFoundException
        raise Errors::MalformedRequestException
      rescue Aws::SNS::Errors::StaleTagException
        raise Errors::MalformedRequestException
      end
    end

    def _get_full_phone_number(user)
      if user.phone_number == nil
        raise Errors::InvalidStateError
      end
      return "+1#{user.phone_number.to_s}"
    end

    # phone_number: String w/ country code
    def _build_and_log_aws_message(phone_number, message)
      msg = {
        phone_number: phone_number,
        message: message,
        message_attributes: @message_attributes,
      }
      @logger.debug msg
      return msg
    end
  end
end
