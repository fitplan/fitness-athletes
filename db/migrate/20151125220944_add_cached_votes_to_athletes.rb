class AddCachedVotesToAthletes < ActiveRecord::Migration
  def self.up
    add_column :athletes, :cached_votes_total, :integer, :default => 0
    add_column :athletes, :cached_votes_score, :integer, :default => 0
    add_column :athletes, :cached_votes_up, :integer, :default => 0
    add_column :athletes, :cached_votes_down, :integer, :default => 0
    add_index  :athletes, :cached_votes_total
    add_index  :athletes, :cached_votes_score
    add_index  :athletes, :cached_votes_up
    add_index  :athletes, :cached_votes_down

    # force caching of existing votes
    Athlete::Base.find_each(&:update_cached_votes)
  end

  def self.down
    remove_column :athletes, :cached_votes_total
    remove_column :athletes, :cached_votes_score
    remove_column :athletes, :cached_votes_up
    remove_column :athletes, :cached_votes_down
  end
end
