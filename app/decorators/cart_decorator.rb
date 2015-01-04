class CartDecorator < Draper::Decorator
  delegate_all

  def error_code
    if response
      response.fetch('error', {}).fetch('code', {})
    else
      nil
    end
  end
end
