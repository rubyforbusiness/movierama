require 'rails_helper'
require 'capybara/rails'
require 'support/pages/movie_list'
require 'support/with_user'

RSpec.describe 'filter movie list', type: :feature do
  with_logged_in_user

  let(:page) { Pages::MovieList.new }

  before do
    author = User.create(
      uid:  'null|54321',
      name: 'Bob'
    )
    me_user = User.find(uid: RspecSupportWithUser::MOCK_UID).first
    @m_liked = Movie.create(
      title:        'Empire strikes back',
      description:  'Who\'s scruffy-looking?',
      date:         '1980-05-21',
      created_at:   Time.parse('2014-10-01 10:30 UTC').to_i,
      user:         author,
      liker_count:  1,
      hater_count:  0,
    )
    VotingBooth.new(me_user, @m_liked).vote(:like)

    @m_hated = Movie.create(
      title:        'Teenage mutant nija turtles',
      description:  'Technically, we\'re turtles.',
      date:         '2014-10-17',
      created_at:   Time.parse('2014-10-01 10:35 UTC').to_i,
      user:         author,
      liker_count:  0,
      hater_count:  0
    )

    @m_novote = Movie.create(
      title:        'Singin\' In the Rain',
      description:  'Dancing from silence to talkies',
      date:         '1900-01-02',
      created_at:   Time.parse('2014-10-01 10:40 UTC').to_i,
      user:         author,
      liker_count:  0,
      hater_count:  0
    )

    @liked_titles = [@m_liked].map(&:title)
    @hated_titles = [@m_hated].map(&:title)
  end

  before { page.open }

  it 'filters movies to show only those I liked' do
    page.filter_by('I liked')
    expect(page.movie_titles).to eq(@liked_titles)
  end
end



