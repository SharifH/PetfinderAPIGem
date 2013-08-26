require 'json'
require 'open-uri'
require 'digest/md5'
require 'pry'
require 'nokogiri'
require 'date'

class PetToken
  attr_accessor  :token_hash, :sig, :expires


  def initialize
    key_secret="#{ENV['PET_SECRET']}key=#{ENV['PET_KEY']}"
    md5 = Digest::MD5.hexdigest(key_secret)
    @token_hash = Hash.new
    @token_hash[:md5] = md5
    @token_hash[:time] = Time.now
    expires = Date.new
  end

  def get_token
   url = "http://api.petfinder.com/auth.getToken?key=#{ENV['PET_KEY']}&sig=#{@token_hash[:md5]}"
   updated_url = URI.encode(url)
   result = Nokogiri::XML(open(updated_url.strip).read)
   @token_hash[:token] = result.xpath("//auth//token/text()").text.strip
   parsed_date = Time.at(result.xpath("//auth/expires/text()").text.strip.to_i)
   @token_hash[:expires] = parsed_date.strftime('%a %d %b %Y %I:%M:%S %p')
  end

end
