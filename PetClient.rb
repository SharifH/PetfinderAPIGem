require 'json'
require 'open-uri'
require 'digest/md5'
require 'pry'
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
    @@token_hash[:expires] = parsed_date.strftime('%a %d %b %Y %I:%M:%S %p')
  end


  def self.breed_list(animal)
    search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&format=json&token=#{@@token_hash[:token]}"
    sig = Digest::MD5.hexdigest(search_string)
    url = "http://api.petfinder.com/breed.list?key=#{ENV['PET_KEY']}&animal=#{animal}&format=json&token=#{@@token_hash[:token]}&sig=#{sig}"
    updated_url = URI.encode(url)
    result = JSON.parse(open(updated_url.strip).read)
  end

  def self.load_breeds(pet)
    pet[:breeds] = breed_list(pet[:name])['petfinder']['breeds']['breed'].map { |b|
        b["$t"]
    }
  end

  def self.build_url(search_string)
    sig = Digest::MD5.hexdigest(search_string)
    partial_string = search_string.scan(/key.*/)[0]
    url = "http://api.petfinder.com/pet.find?"+ partial_string+"&sig=#{sig}"
    updated_url = URI.encode(url)
    JSON.parse(open(updated_url.strip).read)
  end

  def self.search_listings(pet, options={})
    animal = (pet[:name].nil?) ? false : pet[:name]
    # if options[:breeds].nil? && options[:breeds].empty?
    #   breed_flag = false
    # elsif options[:breeds].nil? || options[:breeds].empty?
    #   breed_flag = false
    # else
    #   breed_flag = true
      breeds = (options[:breeds].nil? || options[:breeds].empty?) ? "" : options[:breeds]
    #end
    size = options[:size].nil? ? "" : options[:size]
    sex = options[:sex].nil? ? "" : options[:sex]
    location = options[:location].nil? ? "" : options[:location]
    age = options[:age].nil? ? "" : options[:age]
    offset = options[:offset].nil? ? "" : options[:offset]
    count = options[:count].nil? ? "" : options[:count]
    result_set = []


    # this is a custom option not supported by API
    distance = options[:distance].nil? ? "" : options[:distance]
    pure = options[:pure].nil? ? "" : options[:pure]
    #
    # if animal && breed_flag && size && sex && location && age && offset && count
      if breeds
        breeds.each { |breed|
          search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&size=#{size}&breed=#{breed}&sex=#{sex}&location=#{location}&age=#{age}&offset=#{offset}&count=#{count}&format=json&token=#{@@token_hash[:token]}"
          result_set << build_url(search_string)
          binding.pry
        }
      else
        search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&size=#{size}&sex=#{sex}&location=#{location}&age=#{age}&offset=#{offset}&count=#{count}&format=json&token=#{@@token_hash[:token]}"
        result_set << build_url(search_string)
        binding.pry
      end
    # elsif animal && breed_flag && location && count && (!offset && !age && !size)
    #       breeds.each { |breed|
    #         search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&breed=#{breed}&location=#{location}&count=#{count}&format=json&token=#{@@token_hash[:token]}"
    #         result_set << build_url(search_string)
    #       }
    # elsif animal && breed_flag && location && offset && count && (!age && !size)
    #       breeds.each { |breed|
    #         search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&breed=#{breed}&offset=#{offset}&location=#{location}&count=#{count}&format=json&token=#{@@token_hash[:token]}"
    #         result_set << build_url(search_string)
    #       }
    # elsif animal && breed_flag && location && offset && (!count && !age && !size)
    #       breeds.each { |breed|
    #         search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&breed=#{breed}&offset=#{offset}&location=#{location}&format=json&token=#{@@token_hash[:token]}"
    #         result_set << build_url(search_string)
    #       }
    # elsif animal && breed_flag && location && age && offset && (!count && !size)
    #       breeds.each { |breed|
    #         search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&breed=#{breed}&age=#{age}&offset=#{offset}&location=#{location}&format=json&token=#{@@token_hash[:token]}"
    #         result_set << build_url(search_string)
    #       }
    # elsif animal && breed_flag && location && age && count && (!offset && !size)
    #       breeds.each { |breed|
    #         search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&breed=#{breed}&age=#{age}&location=#{location}&count=#{count}&format=json&token=#{@@token_hash[:token]}"
    #         result_set << build_url(search_string)
    #       }
    #       binding.pry
    # elsif animal && breed_flag && location && age && offset && !size
    #       breeds.each { |breed|
    #         search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&breed=#{breed}&age=#{age}&offset=#{offset}&location=#{location}&format=json&token=#{@@token_hash[:token]}"
    #         result_set << build_url(search_string)
    #       }
    # elsif animal && breed_flag && location && age && offset && size && !count
    #       breeds.each { |breed|
    #         search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&breed=#{breed}&age=#{age}&size=#{size}&offset=#{offset}&location=#{location}&format=json&token=#{@@token_hash[:token]}"
    #         result_set << build_url(search_string)
    #       }
    # elsif animal && size && sex && location && age && offset && count
    #   search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&size=#{size}&sex=#{sex}&location=#{location}&age=#{age}&offset=#{offset}&count=#{count}&format=json&token=#{@@token_hash[:token]}"
    #   result_set << build_url(search_string)
    # elsif animal && sex && location && age && offset && count
    #   search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&sex=#{sex}&location=#{location}&age=#{age}&offset=#{offset}&count=#{count}&format=json&token=#{@@token_hash[:token]}"
    #   result_set << build_url(search_string)
    # elsif animal && location && age && offset && count
    #   search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&location=#{location}&age=#{age}&offset=#{offset}&count=#{count}&format=json&token=#{@@token_hash[:token]}"
    #   result_set << build_url(search_string)
    # elsif animal && age && offset && count
    #   search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&age=#{age}&offset=#{offset}&count=#{count}&format=json&token=#{@@token_hash[:token]}"
    #   result_set << build_url(search_string)
    # elsif animal && location && offset && count
    #   search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&location=#{location}&offset=#{offset}&count=#{count}&format=json&token=#{@@token_hash[:token]}"
    #   result_set << build_url(search_string)
    # elsif animal && location && count
    #   search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&location=#{location}&count=#{count}&format=json&token=#{@@token_hash[:token]}"
    #   result_set << build_url(search_string)
    # elsif animal && location
    #   search_string = "#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}&animal=#{animal}&location=#{location}&format=json&token=#{@@token_hash[:token]}"
    #   result_set << build_url(search_string)
    # else
    #   result_set << "invalid request"
    # end

  end

end
