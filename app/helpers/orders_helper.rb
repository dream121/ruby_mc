module OrdersHelper
  def expiration_years
    this_year = Time.now.year
    this_year.upto(this_year + 20)
  end
end
