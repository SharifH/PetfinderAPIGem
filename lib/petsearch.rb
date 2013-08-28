require 'json'
require 'open-uri'
require 'digest/md5'
require 'nokogiri'
require 'date'
require 'petsearch/PetClient'

class PetSearch
  attr_accessor :dog, :cat, :bird, :reptile, :horse, :pig, :barnyard, :smallfurry

  def initialize
    @dog = {:name => 'dog', :breeds => []}
    @cat = {:name => 'cat', :breeds => []}
    @bird = {:name => 'bird', :breeds => []}
    @reptile = {:name => 'reptile', :breeds => []}
    @horse = {:name => 'horse', :breeds => []}
    @pig = {:name => 'horse', :breeds => []}
    @barnyard = {:name => 'horse', :breeds => []}
    @smallfurry = {:name => 'smallfurry', :breeds => []}
  end


end



