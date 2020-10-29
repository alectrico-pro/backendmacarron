module ExceptionHandler

  extend ActiveSupport::Concern
=begin

  class InvalidToken         < StandardError; end
  class NotReader            < StandardError; end
  class NotReaderId          < StandardError; end
  class NotClientId          < StandardError; end
  class InvalidCredentials   < StandardError; end
  class RequestNotAuthorized < StandardError; end
  class NotAuthTokenPresent  < StandardError; end
  class NotOriginAllowed     < StandardError; end
=end
  #provide the more graceful 'included' method
  class InvalidToken         < StandardError; end

  included do

    rescue_from InvalidToken do |e|
      json_response({ message: e.message }, :unprocessable_entity )
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message },:not_found )
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from NotOriginAllowed do |e|
      json_response({ message: e.message},  :unauthorized )
    end

    rescue_from NotAuthTokenPresent do |e|
      json_response({ message: e.message},  :unauthorized )
    end

    rescue_from RequestNotAuthorized do |e|
      json_response({ message: e.message}, :unauthorized )
    end

    rescue_from NotReader do |e|
      json_response({ message: e.message}, :unauthorized )
    end

    rescue_from NotReaderId do |e|
      json_response({ message: e.message}, :unauthorized )
    end

    rescue_from NotClientId do |e|
       json_response({ message: e.message}, :unauthorized )
    end

    rescue_from MacarronAusente do |e|
       json_response({ message: e.message}, :unauthorized )
    end

    rescue_from CargaInvalida do |e|
       json_response({ message: e.message}, :unauthorized )
    end

    rescue_from InvalidCredentials do |e|
      #require ok de estatus para que lo procese amp-runtime
      json_response({ message: e.message}, :ok )
    end


  end

end
