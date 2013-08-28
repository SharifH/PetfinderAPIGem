require 'json'
require 'open-uri'
require 'digest/md5'
require 'nokogiri'
require 'date'


class PetClient

  @@token_hash = Hash.new

  def initialize
  end

  def self.get_token
    key_secret="#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}"
    md5 = Digest::MD5.hexdigest(key_secret)
    @@token_hash = Hash.new
    @@token_hash[:md5] = md5
    @@token_hash[:time] = Time.now
    expires = Date.new
    url = "http://api.petfinder.com/auth.getToken?key=#{ENV['PET_KEY']}&sig=#{@@token_hash[:md5]}"
    updated_url = URI.encode(url)
    result = Nokogiri::XML(open(updated_url.strip).read)
    @@token_hash[:token] = result.xpath("//auth//token/text()").text.strip
    parsed_date = Time.at(result.xpath("//auth/expires/text()").text.strip.to_i)
    @@token_hash[:expires] = Time.parse(parsed_date.strftime('%a %d %b %Y %I:%M:%S %p'))
  end


  def self.breed_list(animal)
    search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&format=json&token=#{@@token_hash[:token]}"
    sig = Digest::MD5.hexdigest(search_string)
    url = "http://api.petfinder.com/breed.list?key=#{ENV['PET_KEY']}&animal=#{animal}&format=json&token=#{@@token_hash[:token]}&sig=#{sig}"
    updated_url = URI.encode(url)
    result = JSON.parse(open(updated_url.strip).read)
  end

  ##load all the breeds
  def self.load_breeds(pet)
    pet[:breeds] = breed_list(pet[:name])['petfinder']['breeds']['breed'].map { |b|
        b["$t"]
    }
  end

  ## DRY-ish method for API lookup
  def self.build_url(search_string, random=nil, id=nil)
    sig = Digest::MD5.hexdigest(search_string)
    partial_string = search_string.scan(/key.*/)[0]
    if random && id.nil? == true
      url = "http://api.petfinder.com/pet.getRandom?"+ partial_string+"&sig=#{sig}"
    elsif !random && id.nil? == true
      url = "http://api.petfinder.com/pet.find?"+ partial_string+"&sig=#{sig}"
    else
      url = "http://api.petfinder.com/pet.get?"+ partial_string+"&sig=#{sig}"
    end
    updated_url = URI.encode(url)
    JSON.parse(open(updated_url.strip).read)
  end

  def self.get_pet(id)
    search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&id=#{id}&format=json&token=#{@@token_hash[:token]}"
    result = build_url(search_string, nil, id)
  end

  def self.search_listings(pet, options={})
    animal = (pet[:name].nil?) ? false : pet[:name]
    breeds = (options[:breeds].nil? || options[:breeds].empty?) ? "" : options[:breeds]
    size = options[:size].nil? ? "" : options[:size]
    sex = options[:sex].nil? ? "" : options[:sex]
    location = options[:location].nil? ? "" : options[:location]
    age = options[:age].nil? ? "" : options[:age]
    offset = options[:offset].nil? ? "" : options[:offset]
    count = options[:count].nil? ? "" : options[:count]
    random = (options[:random].nil? || options[:random]==false) ? false : true
    result_set = []

    # this is a custom option not supported by API
    distance = options[:distance].nil? ? "" : options[:distance]
    pure = options[:pure].nil? ? "" : options[:pure]

    ### must do loops if breed param
    if breeds && breeds!=""
      breeds.each { |breed|
        ## must have separate random search because do not want to pass in parameters that will break api call, even if empty strings
        if random
         search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&size=#{size}&breed=#{breed}&sex=#{sex}&location=#{location}&output=full&format=json&token=#{@@token_hash[:token]}"
         result_set << build_url(search_string, random)
        else
         search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&size=#{size}&breed=#{breed}&sex=#{sex}&location=#{location}&age=#{age}&offset=#{offset}&count=#{count}&output=full&format=json&token=#{@@token_hash[:token]}"
         result_set << build_url(search_string)
       end
      }
    else
      if random
        search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&size=#{size}&sex=#{sex}&location=#{location}&output=full&format=json&token=#{@@token_hash[:token]}"
        result_set << build_url(search_string, random)
      else
        search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&size=#{size}&sex=#{sex}&location=#{location}&age=#{age}&offset=#{offset}&count=#{count}&output=full&format=json&token=#{@@token_hash[:token]}"
        result_set << build_url(search_string)
      end
    end
  end

end
