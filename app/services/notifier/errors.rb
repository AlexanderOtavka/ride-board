module Notifier::Errors
  class InvalidStateError < Exception
  end
  class AuthError < StandardError
  end
  class ThrottledError < StandardError
  end
  class MalformedRequestException < Exception
  end

  # These should generally be retried
  class ExternalServiceError < StandardError
  end
end
