require 'rails_helper'
require 'capybara/rails'
require 'support/pages/movie_list'
require 'support/with_user'

RSpec.describe 'filter movie list', type: :feature do
  let(:page) { Pages::MovieList.new }


  before { page.open }

  it 'doesn\'t show filter options' do
    expect(page).not_to have_css('.mr-filter')
    expect(page).to have_css('.mr-sorter')
  end

end



