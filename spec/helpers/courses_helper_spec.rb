require 'spec_helper'

describe CoursesHelper do

  describe "review_star_average" do
    it "averages ratings of reviews" do
      reviews = [CourseReview.new(rating: 5), CourseReview.new(rating: 4)]
      expect(helper.review_star_average(reviews)).to eq(4.5)
    end
  end

  describe 'fact_icon' do
    context 'with an svg icon' do
      let(:fact) { create :course_fact, icon: 'foo.svg' }

      it 'should render an image tag' do
        expected = %q(<div class="helper"></div><img alt="Foo" class="img-responsive" src="/images/fact-icons/foo.svg" />)
        expect(helper.fact_icon(fact)).to eq(expected)
      end
    end

    context 'with a font icon' do
      let(:fact) { create :course_fact, icon: 'fa fa-briefcase' }

      it 'should render an icon tag' do
        expect(helper.fact_icon(fact)).to eq('<i class="fa fa-briefcase"></i>')
      end
    end

    context 'with an uploaded image' do
      let(:fact) { create :course_fact, icon: 'fa fa-briefcase' }

      before do
        fact.stub(:image).and_return(true)
        fact.stub_chain(:image, :image, :url).and_return('/path/to/image.jpg')
      end

      it 'should render an image tag' do
        expect(helper.fact_icon(fact)).to eq('<img alt="Image" src="/path/to/image.jpg" />')
      end
    end
  end

end
