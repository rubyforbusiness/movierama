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

      it 'increases the number of movies I like' do
        expect {subject}.to change { user.liked_movies.count }.by 1
      end

      it 'adds the movie to the list I like' do
        expect {subject}.to change {
          user.liked_movies.include? movie
        }.from(false).to(true)
      end
    end

    context 'me hating a movie' do
      subject do
        described_class.new(user, movie).vote(:hate)
      end

      let!(:user) { create(:user) }
      let!(:movie) { create(:movie, user: user) }

      it 'increases the haters of a movie' do
        expect {subject}.to change { movie.haters.count }.by 1
      end

      it 'makes me a hater of a movie' do
        expect {subject}.to change {
          movie.haters.include? user
        }.from(false).to(true)
      end

      it 'increases the number of movies I hate' do
        expect {subject}.to change { user.hated_movies.count }.by 1
      end

      it 'adds the movie to the list I hate' do
        expect {subject}.to change {
          user.hated_movies.include? movie
        }.from(false).to(true)
      end
    end

    context 'me liking a movie I used to hate' do
      subject do
        described_class.new(user, movie).vote(:like)
      end

      let!(:user) { create(:user) }
      let!(:movie) { create(:movie, user: user) }

      before do
        movie.hater_count += 1
        movie.haters.add user
        user.hated_movies.add movie
      end

      it 'decreases the haters of a movie' do
        expect {subject}.to change { movie.haters.count }.by -1
      end

      it 'stops me being a hater of a movie' do
        expect {subject}.to change {
          movie.haters.include? user
        }.from(true).to(false)
      end

      it 'decreases the number of movies I hate' do
        expect {subject}.to change { user.hated_movies.count }.by -1
      end

      it 'removes the movie from the list I hate' do
        expect {subject}.to change {
          user.hated_movies.include? movie
        }.from(true).to(false)
      end
    end

    context 'me hating a movie I used to like' do
      subject do
        described_class.new(user, movie).vote(:hate)
      end

      let!(:user) { create(:user) }
      let!(:movie) { create(:movie, user: user) }

      before do
        movie.liker_count += 1
        movie.likers.add user
        user.liked_movies.add movie
      end

      it 'decreases the likers of a movie' do
        expect {subject}.to change { movie.likers.count }.by -1
      end

      it 'stops me being a liker of a movie' do
        expect {subject}.to change {
          movie.likers.include? user
        }.from(true).to(false)
      end

      it 'decreases the number of movies I like' do
        expect {subject}.to change { user.liked_movies.count }.by -1
      end

      it 'removes the movie from the list I like' do
        expect {subject}.to change {
          user.liked_movies.include? movie
        }.from(true).to(false)
      end
    end
  end
  describe '#unvote'
end