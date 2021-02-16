require 'rails_helper'

RSpec.describe VotingBooth do
  describe '#vote' do
    context 'me liking a movie' do
      subject do
        described_class.new(user, movie).vote(:like)
      end

      let!(:user) { create(:user) }
      let!(:movie) { create(:movie, user: user) }

      it 'increases the likers of a movie' do
        expect {subject}.to change { movie.likers.count }.by 1
      end

      it 'makes me a liker of a movie' do
        expect {subject}.to change {
          movie.likers.include? user
        }.from(false).to(true)
      end
      it 'increases the number of movies I like'
      it 'adds the movie to the list I like'
    end
  end
  describe '#unvote'
end