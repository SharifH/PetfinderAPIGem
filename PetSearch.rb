require 'json'
require 'open-uri'
require 'digest/md5'
require 'pry'
require 'nokogiri'
require 'date'
require './PetClient'

class Pet
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

#method to get breeds
  # p = Pet.new
  # PetClient.get_token
  # PetClient.load_breeds(p.cat)
  # puts p.cat[:breeds]
p = Pet.new
options = Hash.new
PetClient.get_token
options[:location] = 94123
options[:count] =  5
options[:age] = 'Baby'
options[:breeds] = []
options[:breeds] << "chihuahua"
options[:size] = "S"
PetClient.search_listings(p.dog, options)



