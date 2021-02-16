require 'rails_helper'

RSpec.describe VotingBooth do
  describe '#vote' do
    context 'me liking a movie' do
      let(:movie) { }
      it 'increases the likers of a movie' do
        expect(subject).to change(movie.likers.count).by 1
      end
      it 'makes me a liker of a movie'
      it 'increases the number of movies I like'
      it 'adds the movie to the list I like'
    end
  end
  describe '#unvote'
end