require 'rails_helper'
require 'capybara/rails'
require 'support/pages/movie_list'
require 'support/with_user'

RSpec.describe 'filter movie list', type: :feature do
  with_logged_in_user

  let(:page) { Pages::MovieList.new }

  let!(:user1) { create(:user, :user1) }
  let!(:user2) { create(:user, :user2) }

  before do
    author = User.find(uid: RspecSupportWithUser::MOCK_UID).first
    @empire = Movie.create(
      title:        'Empire strikes back',
      description:  'Who\'s scruffy-looking?',
      date:         '1980-05-21',
      created_at:   Time.parse('2014-10-01 10:30 UTC').to_i,
      user:         author,
      liker_count:  0,
      hater_count:  0,
    )
    VotingBooth.new(user1, @empire).vote(:like)
    VotingBooth.new(user2, @empire).vote(:hate)

  end

  before { page.open }

  it 'shows a list of likers and haters of a movie' do
    expect(page.notification_finder("#{user1.name} likes #{@empire.title}")).to be true
  end

end



