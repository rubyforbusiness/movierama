# Cast or withdraw a vote on a movie
class VotingBooth
  def initialize(user, movie)
    @user  = user
    @movie = movie
  end

  def vote(like_or_hate)
    movie_set, user_set = case like_or_hate
      when :like then [@movie.likers, @user.liked_movies]
      when :hate then [@movie.haters, @user.hated_movies]
      else raise
    end
    unvote # to guarantee consistency
    movie_set.add(@user)
    user_set.add(@movie)
    _update_counts
    self
  end
  
  def unvote
    @movie.likers.delete(@user)
    @movie.haters.delete(@user)
    @user.liked_movies.delete(@movie)
    @user.hated_movies.delete(@movie)
    _update_counts
    self
  end

  private

  def _update_counts
    @movie.update(
      liker_count: @movie.likers.size,
      hater_count: @movie.haters.size)
  end
end
