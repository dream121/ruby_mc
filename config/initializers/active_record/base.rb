class ActiveRecord::Base  
  def self.escape_sql(clause, *rest)
    self.send(:sanitize_sql_array, rest.empty? ? clause : ([clause] + rest))
  end
end
