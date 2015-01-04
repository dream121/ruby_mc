require 'spec_helper'

describe UserDecorator do

  let(:user) { create(:user).decorate }

  describe '#first_name' do
    context 'when Facebook info exists' do
      before do
        user.info = { 'first_name' => 'Tommy' }
      end

      it 'returns the first name from the info hash' do
        expect(user.first_name).to eq('Tommy')
      end
    end

    context 'when Facebook info does not exist' do
      before do
        user.info = {}
      end

      context 'when a name field exists' do
        it 'returns the first name based on the full name' do
          expect(user.first_name).to eq('Tom')
        end
      end

      context 'when a name field does not exist' do
        before do
          user.name = nil
        end

        context 'when an email address exists' do
          before do
            user.email = 'frank@example.com'
          end

          it 'returns the first name based on email address' do
            expect(user.first_name).to eq('Frank')
          end
        end

        context 'when an email address does not exist' do
          before do
            user.email = nil
          end

          it 'returns "Accomplice user"' do
            expect(user.first_name).to eq('Accomplice User')
          end
        end
      end
    end
  end
end
