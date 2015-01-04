module DocumentsHelper
  def set_parent
    id_param = params.keys.detect do |p|
      %w(instructor_id course_id).include?(p.to_s)
    end

    klass = id_param.sub(/_id$/, '').capitalize.constantize
    @parent = klass.friendly.find(params[id_param]).decorate
  end
end
