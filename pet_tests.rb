require 'test/unit'
require './petsearch'
require './petclient'


class PetTest < Test::Unit::TestCase


  def test_pet_test
    p = Pet.new
    assert_instance_of(Pet,p)
  end

  def test_dog
    p = Pet.new
    assert_equal "dog", p.dog[:name]
  end

  def test_pet_client
    p = PetClient.new
    assert_instance_of(PetClient, p)
  end

end
