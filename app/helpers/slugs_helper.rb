module SlugsHelper
  def update_slug(record, new_slug)
    if slug_changed?(record, new_slug)
      record.update_attribute! :slug, new_slug
    elsif slug_reset?(record, new_slug)
      record.slug = nil
      record.save!
    end
  end

  def slug_changed?(record, new_slug)
    !new_slug.blank? && (record.slug != new_slug)
  end

  def slug_reset?(record, new_slug)
    new_slug.blank?
  end
end
