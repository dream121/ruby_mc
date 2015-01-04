# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

course_titles = [
  'How to Reason With Robots',
  'How to Launder with Confidence',
  'How to Train Weasels',
  'How to Build Time Machines',
  'How to Hide from Bears',
  'How to Avoid Uncomfortable Situations'
]

skills = [
  'Pretending',
  'Speedwalking',
  'Vaulting',
  'Archaeology',
  'Training',
  'Maintenance'
]

roles = [
  'shark expert',
  'nobel prize winning physicist',
  'disgraced politician',
  'post-it-note inventor',
  'triple-crown winning jockey',
  'recognizable television personality'
]

instructor_names = [
  'Will Smith',
  'James Brown',
  'Oprah Winfrey',
  'Sir Isaac Newton',
  'Leonardo da Vinci',
  'Lady Gaga'
]

categories = [
  'Business',
  'Winter'
]

chapters = [
  'Getting Started',
  'Learning Stuff',
  'Wrapping Up'
]

hipster_long = "Ennui selfies direct trade, veniam viral farm-to-table commodo fixie plaid. Eiusmod sed consequat commodo odio deep v, wayfarers laboris. Aute synth gentrify blog, drinking vinegar biodiesel commodo scenester cardigan tempor forage nesciunt. Street art disrupt paleo Brooklyn, cupidatat retro Odd Future cornhole ad sartorial freegan Tonx four loko. Gentrify assumenda incididunt in sint mustache vinyl. American Apparel artisan cliche bitters labore wolf, synth Godard laboris. Butcher Odd Future delectus letterpress bicycle rights."
hipster_short = "Neutra sriracha consequat sint chillwave sustainable 90's banh mi. Est letterpress Etsy, incididunt dolor cillum keytar Odd Future yr Banksy banjo sunt pickled."
video = "2746311537001"

facts = [
  { kind: 'interaction', position: 1, title: "Hang-Outs with Instructor", description: hipster_short, icon: "fa fa-group" },
  { kind: 'interaction', position: 2, title: "Group Discussions", description: hipster_short, icon: "fa fa-comments" },
  { kind: 'interaction', position: 3, title: "Class Critiques", description: hipster_short, icon: "fa fa-check-circle" },

  { kind: 'asset', position: 1, title: "Videos", number: "35", description: hipster_short, icon: "fa fa-youtube-play" },
  { kind: 'asset', position: 2, title: "Assignments", number: "2", description: hipster_short, icon: "fa fa-youtube-play" },
  { kind: 'asset', position: 3, title: "Bonus Materials", number: "19", description: hipster_short, icon: "fa fa-suitcase" },

  { kind: 'headline', position: 1, title: "How to compose your photo like a pro", description: hipster_short },
  { kind: 'headline', position: 1, title: "How to fine-tune your detailing skills", description: hipster_short },
  { kind: 'headline', position: 1, title: "How to give & take feedback", description: hipster_short },

  { kind: 'statistic', position: 1, title: "Lessons", number: "12", description: hipster_short, icon: "fa fa-youtube-play" },
  { kind: 'statistic', position: 2, title: "Learning Tools", number: "3", description: hipster_short, icon: "fa fa-youtube-play" },
  { kind: 'statistic', position: 3, title: "Bonus Videos", number: "5", description: hipster_short, icon: "fa fa-suitcase" },
  { kind: 'statistic', position: 4, title: "Time with Instructor", number: "+", description: hipster_short, icon: "fa fa-suitcase" },
]

users = [
  User.create(email: 'user1@example.com'),
  User.create(email: 'user2@example.com'),
  User.create(email: 'user3@example.com')
]

reviews = [
  { position: 1, user: users[0], review: hipster_short, rating: 5, visible: true, featured: true, location: 'New York City', name: 'Bob Smith' },
  { position: 2, user: users[1], review: hipster_short, rating: 4, visible: true, featured: true, location: 'Los Angeles', name: 'Alice Jenkins' },
  { position: 3, user: users[2], review: hipster_short, rating: 5, visible: true, featured: true, location: 'Miami', name: 'Claire Jones' }
]

ActiveRecord::Base.transaction do

  course_titles.each_with_index do |title, i|

    slug = title.split(' ').last
    book = Product.create(kind: 'book', name: "#{slug}: A Primer", price: 999)
    skill = skills[i]
    role = roles[i]

    instructor = Instructor.create!(
      name: instructor_names[i],
      email: "instructor#{i}@example.com",
      testimonials: 'so very good',
      short_bio: hipster_short,
      long_bio: hipster_long
    )

    headline = "<h1>#{instructor.name}</h1><h2>teaches you #{skill}</h2><h3>in this online class</h3>"

    course = Course.create(
      title: title,
      slug: slug.downcase,
      price: 9999,
      start_date: Time.now,
      category: i % 2 == 0 ? categories[0] : categories[1]
    )

    course.create_detail(
      role: role,
      skill: skill,
      headline: headline,
      intro_video_id: video,
      short_description: hipster_short,
      invitation_statement: 'You should sign up for this course!',
      overview: hipster_long,
      lessons_introduction: 'Here is what we will learn.',
      welcome_statement: 'Welcome to the course!',
      welcome_back_statement: 'Welcome back!',
      featured_review: "Wow! All my questions about #{slug.downcase} have been answered!",
      total_video_duration: '55:55',

    )

    course.instructors << instructor

    reviews.each { |review| course.reviews.create(review) }

    facts.each { |fact| course.facts.create(fact) }

    product = course.create_product(
      price: 10000,
      name: course.title,
      kind: 'course'
    )

    product.recommendations.create related_product: book

    chapters.each_with_index do |chapter_title, i|
      course.chapters.create(
        number: i + 1,
        duration: '3:50',
        brightcove_id: video,
        title: chapter_title,
        abstract: hipster_short
      )
    end
  end
end
