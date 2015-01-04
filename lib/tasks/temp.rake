namespace :temp do

  namespace :sample_comments do
    desc 'create sample comments'
    task create: :environment do
      course = Course.friendly.find 'make-connections'
      admin = User.find_by email: 'jreynolds@carbonfive.com'
      user = User.find_by email: 'toast@drtoast.com'
      topic1 = course.comments.create user: admin, title: 'Topic 1', comment: 'Here is topic 1', position: 1
      topic2 = course.comments.create user: admin, title: 'Topic 2', comment: 'Here is topic 2', position: 2
      topic3 = course.comments.create user: admin, title: 'Topic 3', comment: 'Here is topic 3', position: 3

      comment1 = course.comments.create user: user, parent: topic1, comment: 'Here is the first reply to topic 1'
      comment2 = course.comments.create user: user, parent: topic1, comment: 'Here is the second reply to topic 1'
      comment3 = course.comments.create user: user, parent: comment1, comment: 'Here is a reply to topic 1 (nested 1 level deep)'
      comment4 = course.comments.create user: user, parent: comment3, comment: 'Here is a reply to topic 1 (nested 2 levels deep)'
    end

    task destroy: :environment do
      CourseComment.destroy_all
    end
  end

  task create_products: :environment do
    Course.all.each do |course|
      puts "Creating product for #{course.title}"
      course.create_product(name: course.title, price: course.price) unless course.product.present?
    end
  end

  task convert_orders: :environment do
    converter = OrderConverter.new
    Order.all.each do |order|
      converter.convert! order
    end
  end

  namespace :course do
    desc 'create course detail'
    task create_detail: :environment do
      Course.all.each do |c|
        c.create_detail unless c.detail.present?
      end
    end
  end
end
