PetfinderAPIGem
===============

###Instructions for PetFinder Gem
Always get a new token.  Tokens expire after about 60 minutes.  So you can check to see if your existing token if valid by `PetClient.token_hash[:expires] > Time.now + 3600` or, simply get a new token with `PetClient.get_token`, which you have to do anyway upon first instantiating a call.

*** <bold> IMPORTANT </bold> *** You must have an ENV variable set up with PET_KEY and PET_SECRET in the root of your app.  This gem requires the use of Foreman.

There are two classes, `PetSearch` and `PetClient`.

##PetSearch
You'll need to create a new PetSearch instance for this gem to work.  Each instance contains hashes of of animals for which can search and populate data.  The options include:
* :dog, :cat, :bird, :reptile, :horse, :pig, :barnyard, :smallfurry, :options

So, first create your new instance with `p = PetSearch.new`.  Great, now you can do p.dog and p.cat, etc.  Each instance variable has a hash containing a name and an appty array for breeds.  So, let's say you want to populate all the cat breeds. One line does it . . .
```PetClient.load_breeds(p.cat)```
Now p.cat[:breeds] contains the entire list of cat breeds.

##PetClient
more soon