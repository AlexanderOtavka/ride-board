module Notifier::Errors
  class InvalidStateError < RuntimeError
  end
  class AuthError < StandardError
  end
  class ThrottledError < StandardError
  end
  class MalformedRequestException < RuntimeError
  end

  # These should generally be retried
  class ExternalServiceError < StandardError
  end
end
