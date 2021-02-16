require 'rails_helper'
require 'capybara/rails'
require 'support/pages/movie_list'
require 'support/with_user'

RSpec.describe 'filter movie list', type: :feature do
  let(:page) { Pages::MovieList.new }

  before do
    author = User.create(
      uid:  'null|54321',
      name: 'Bob'
    )
    @m_liked = Movie.create(
      title:        'Empire strikes back',
      description:  'Who\'s scruffy-looking?',
      date:         '1980-05-21',
      created_at:   Time.parse('2014-10-01 10:30 UTC').to_i,
      user:         author,
      liker_count:  0,
      hater_count:  0,
    )

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
    @all_titles = [@m_liked, @m_hated, @m_novote].map(&:title)
  end

  before { page.open }

  it 'doesn\'t show filter options' do
    expect(page).not_to have_css('.mr-filter')
    expect(page).to have_css('.mr-sorter')
  end

end



