module CoursesHelper

  def price_in_dollars(cents)
    dollars = (price_in_dollars_text(cents)).split('.')[0].sub(/^\$/, '')
    content_tag(:span,'$', { class: 'price-dollar-sign'}).concat(dollars)
  end

  def fact_icon(fact)
    if fact.image
      image_tag(fact.image.image.url(:original))
    elsif fact.icon && fact.icon.match(/\.svg$/)
      content_tag(:div, '', { class: 'helper' }).concat(image_tag("fact-icons/#{fact.icon}", class: 'img-responsive'))
    else
      content_tag(:i, '', { class: fact.icon })
    end
  end

  def form_hints(string)
    '<span class="col-xs-offset-2 col-sm-offset-2 col-md-offset-2 col-lg-offset-2">'+string+'</span>'
  end

  def price_in_dollars_text(cents)
    number_to_currency Money.new(cents.to_i).dollars
  end

  def course_path_for_current_user(course)
    if policy(course).show_enrolled?
      enrolled_course_path(course)
    else
      course_path(course)
    end
  end

  def num_full_stars_in_rating(rating)
    rating.to_i
  end

  def num_half_stars_in_rating(rating)
    decimal_part = (rating - rating.to_i)
    (0.44 < decimal_part) ? 1 : 0
  end

  def num_empty_stars_in_rating(rating)
    5 - num_full_stars_in_rating(rating) - num_half_stars_in_rating(rating)
  end

  def review_star_average(reviews)
    stars = reviews.map(&:rating)
    if stars.size > 0
      stars.inject(:+).to_f / stars.size
    else
      5
    end
  end

  def answered_questions(count, sing, plural)
    if count == 0
      "#{count} #{plural}"
    elsif count == 1
      "#{count} #{sing}"
    else
      "#{count} #{plural}"
    end
  end

end
