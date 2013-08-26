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


  def self.breed_list(animal)
    client = PetToken.new
    client.get_token
    search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&format=json&token=#{client.token_hash[:token]}"
    sig = Digest::MD5.hexdigest(search_string)
    url = "http://api.petfinder.com/breed.list?key=#{ENV['PET_KEY']}&animal=#{animal}&format=json&token=#{client.token_hash[:token]}&sig=#{sig}"
    updated_url = URI.encode(url)
    result = JSON.parse(open(updated_url.strip).read)
  end

  def self.load_breeds(pet_instance)
    pet_instance.dog[:breeds] = breed_list(pet_instance.dog[:name])['petfinder']['breeds']['breed'].map { |b|
        b["$t"]

    }
    binding.pry
  end

end

p = Pet.new
Pet.load_breeds(p)