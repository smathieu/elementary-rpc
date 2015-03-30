require 'elementary'

class BaseElementaryClient
  attr_accessor :connection

  def invoke_error_service(request)
    result = connection.rpc.error(request)
    return handle(result)
  end

  def invoke_bad_request_data_service(request)
    result = connection.rpc.bad_request_data_method(request)
    return handle(result)
  end

  def invoke_service_not_found_service(request)
    result = connection.rpc.service_not_found_method(request)
    return handle(result)
  end

  def invoke_echo_service(request)
    result = connection.rpc.echo(request)
    return handle(result)
  end

  def handle(result)
    result.value
    return result
  end

end