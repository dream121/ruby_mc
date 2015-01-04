class DocumentPolicy < CoursePolicy
  def download?
    if record.document.respond_to?(:file?)
      record.document.file? && (admin? || user.courses.include?(record.documentable))
    else
      record.document.document.file? && (admin? || user && user.courses.include?(record.documentable))
    end

  end

  def index?
    admin?
  end
end
