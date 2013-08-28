PetfinderAPIGem
===============

##Instructions for PetFinder Gem
Always get a new token.  Tokens expire after about 60 minutes.  So you can check to see if your existing token if valid by `PetClient.token_hash[:expires] > Time.now + 3600` or, simply get a new token with `PetClient.get_token`, which you have to do anyway upon first instantiating a call.

*** <bold> IMPORTANT </bold> *** You must have an ENV variable set up with PET_KEY and PET_SECRET in the root of your app.  This gem requires the use of Foreman. If you want to hardcode your keys, think twice. Think thrice, but always play nice.

There are two classes, `PetSearch` and `PetClient`.

###PetSearch
You'll need to create a new PetSearch instance for this gem to work.  Each instance contains hashes of of animals for which can search and populate data.  The options include:

* Dog, cat, bird, reptile, horse, pig, barnyard, smallfurry

So, first create your new instance with `p = PetSearch.new`.  Great, now you can do p.dog and p.cat, etc.  Each instance variable has a hash containing a name and an appty array for breeds.  So, let's say you want to populate all the cat breeds. One line does it . . .
```PetClient.load_breeds(p.cat)```
Now p.cat[:breeds] contains the entire list of cat breeds.

###PetClient
PetFinder's API makes life miserable with requiring you to create multiple MD5 hashes for simple queries and then adding those hash signatures to a URL + keys, secrets, unicorns, and more.  NO MORE, I say.  NO MORE.

* Important - Don't forget your token. `PetClient.get_token` You have three class methods at your disposal: `PetClient.search_listings`, `PetClient.load_breeds`, `PetClient.get_pet`.

For `PetClient.load_breeds`, please see above.

####PetClient.search_listings
You must first create a petsearch instance.  Then call search_listings with PetClient.search_lists(instance.animal_name, options).  'instance.animal_name' must be something like p.dog, p.cat, etc.  Valid names are listed above.  No, error checking is not built in yet. The options hash must first be created and then passes in with any of the following parameters.   Please note, LOCATION must always be included for this search.

* Required - Location. So set `options[:location] = someZIP
* optional - count, i.e. number of results. Set as above
* optional - age.  Valid -> Baby, Young, Adult, Senior
* optional - sex, Valid -> M or F
* optional - size, Valid -> S, M, L, XL
* optional - breeds.  Must add to options[:breeds] with push or <<
* optional - random. Valid -> true or false.  Returns 1 random result
* optional - offset.  Look at your JSON output.  You'll see your lastOffset field, which means where the search should continue from.  Since the default count is 25, the lastOffset is 25.  So pass in an offset of 25 to continue searching from where you left off

####PetClient.get_pet
You don't need a PetSearch instance for this.  All you need to do is pass in an ID of a valid pet.  Ex. `PetClient.get_pet(27049255)`

# Final Thoughts

I will keep updating this project as time goes on, but I value your input/suggestions.  Thanks folks.  Save pets.  Save lives.  Save the love.
