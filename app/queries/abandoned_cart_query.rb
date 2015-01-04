class AbandonedCartQuery

  def initialize(relation = Cart.all)
    @relation = relation
  end

  def find(from, to, reminder_number)
    @relation.
      where("(reminder_count IS NULL) OR (reminder_count < ?)", reminder_number).
      where("created_at >= ?", from).
      where("created_at < ?", to)
  end

  # def find_each(&block)
  #   find.find_each(&block)
  # end
end
