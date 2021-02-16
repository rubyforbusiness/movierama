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
      liker_count:  0,
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
    VotingBooth.new(me_user, @m_hated).vote(:hate)

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
    @all_titles = [@m_liked, @m_hated, @m_novote].map(&:title)
  end

  before { page.open }

  it 'enables filtering' do
    expect(page).to have_css('.mr-filter')
  end

  it 'filters movies to show only those I liked' do
    page.filter_by('I liked')
    expect(page.movie_titles).to match_array(@liked_titles)
  end

  it 'filters movies to show only those I hated' do
    page.filter_by('I hated')
    expect(page.movie_titles).to match_array(@hated_titles)
  end

  it 'does not filter movies' do
    page.filter_by('No filter')
    expect(page.movie_titles).to match_array(@all_titles)
  end

  context 'filters and sorts' do
    before do
      liker_user_1 = User.create(
        uid:  'liker|112233',
        name: 'User Liker 1'
      )
      hater_user_1 = User.create(
        uid:  'hater|112233',
        name: 'User Hater 1'
      )
      hater_user_2 = User.create(
        uid:  'hater|223344',
        name: 'User Hater 2'
      )
      hater_user_3 = User.create(
        uid:  'hater|334455',
        name: 'User Hater 3'
      )
      me_user = User.find(uid: RspecSupportWithUser::MOCK_UID).first
      VotingBooth.new(me_user, @m_novote).vote(:like)
      VotingBooth.new(liker_user_1, @m_liked).vote(:like)
      @liked_sorted_likers_titles = [@m_liked, @m_novote].map(&:title)

      VotingBooth.new(hater_user_1, @m_novote).vote(:hate)
      VotingBooth.new(hater_user_2, @m_novote).vote(:hate)
      VotingBooth.new(hater_user_3, @m_novote).vote(:hate)
      @liked_sorted_haters_titles = [@m_novote, @m_liked].map(&:title)
    end

    it 'shows movies I like sorted by likers' do
      page.filter_by('I liked')
      page.sort_by('likers')
      expect(page.movie_titles).to eq(@liked_sorted_likers_titles)
    end

    it 'shows movies I like sorted by haters' do
      page.filter_by('I liked')
      page.sort_by('haters')
      expect(page.movie_titles).to eq(@liked_sorted_haters_titles)
    end
  end
end



