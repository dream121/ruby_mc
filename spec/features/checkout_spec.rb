require 'spec_helper'

feature "Checkout", js: true do

  background do
    # @user = create :user
    @product = create :course_product
    @course = @product.course
    @course.instructors << create(:instructor)
    @coupon = @course.coupons.create(code: '20bucks', max_redemptions: 999, price: 2000, expires_at: Time.now + 1.day)
  end

  # Here's a placeholder feature spec to use as an example, uses the default driver.
  scenario "A user should be able to checkout with a coupon" do
    VCR.use_cassette 'checkout', record: :none do
      # course list
      visit courses_path

      click_link @course.title

      # course marketing page
      expect(current_path).to eq(course_path(@course))

      within '.sidebar .pricing-container' do
        click_link 'Take the Class'
      end

      sleep 1 # FIXME

      # sign up page
      expect(page).to have_content 'sign up with your email address'
      click_link 'sign up with your email address'
      within '#email-form' do
        fill_in 'email', with: 'NewUser@example.com'
        fill_in 'password', with: 'passw0rd'
        fill_in 'password_confirmation', with: 'passw0rd'
        click_button 'Sign Up'
      end

      # checkout
      expect(page).to have_content 'Signed in!'
      expect(current_path).to eq(user_cart_path)

      # coupon
      fill_in 'code', with: '20bucks'
      save_screenshot '/tmp/tmp.png'
      click_button 'Apply'
      expect(page).to have_content 'You save $20'
      expect(page).to have_content '$80'

      # payment
      within('form#new_order') do
        fill_in 'name', with: 'Bob Smith'
        fill_in 'number', with: '4242424242424242'
        fill_in 'cvc', with: '123'
        select '01', from: 'exp-month'
        select Time.now.year + 1, from: 'exp-year'
        fill_in 'address-zip', with: '94107'
        click_button 'Purchase'
      end

      # FIXME: this will periodically fail, likely because of slow Stripe js load time
      expect(page).to have_content 'Thank you for your order!'
      expect(current_path).to eq(enrolled_course_path(@course))

      # new order exists?
      order = Order.last
      expect(order.user.name).to eq('Bob Smith')
      expect(order.user.email).to eq('newuser@example.com') # lowercase
      expect(order.payment.amount).to eq(2000)
      expect(order.payment.paid).to be_true

      # user enrolled in course?
      expect(order.user.courses.last).to eq(@course)
    end
  end

end
