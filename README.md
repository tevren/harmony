Harmony - the memory reduced version ...
=======

                       .,ad88888888baa,
                   ,d8P"""        ""9888ba.
                .a8"          ,ad88888888888a
               aP'          ,88888888888888888a
             ,8"           ,88888888888888888888,
            ,8'            (888888888( )888888888,
           ,8'             `8888888888888888888888
           8)               `888888888888888888888,
           8                  "8888888888888888888)
           8                   `888888888888888888)
           8)                    "8888888888888888
           (b                     "88888888888888'
           `8,        (8)          8888888888888)
            "8a                   ,888888888888)
              V8,                 d88888888888"
               `8b,             ,d8888888888P'
                 `V8a,       ,ad8888888888P'
                    ""88888888888888888P"
                         """"""""""""

Why this new version of an already great gem?
-------

We, at Cohuman, have been using Harmony in our Rspec text suite for javascript unit testing. For performance reasons, the original Harmony gem instantiated one Johnson js runtime per Harmony universe. Envjs was loaded into the runtime once and then each page was instantiated and loaded into this singleton runtime. This lead to a memory explosion since none of the pages created in our test suite are released until the entire suite finished running. Our 700 tests were taking over a gig of memory :(

This is an experimental version of Harmony that instantiates a new Johnson runtime with Envjs for each page created. This means that we maintain the unit test isolation that Harmony pages provide while allowing each page to be garbage collected after the test is run. The penalty is, of course, performance. Creating a new Johnson runtime and loading it with the Envjs methods takes time.

Ideally, Harmony should allow configuration for performance or memory optimization. Should there be demand we will make it happen!


Get the original, and learn more about the API
--------
http://github.com/mynyml/harmony

Install
-------

    # There's a gem dependency bug in rubygems currently, so we'll have to
    # install some dependencies manually. This will be fixed soon.
    gem install stackdeck
    gem install johnson -v "2.0.0.pre3"

		# download this version of the gem and install it manually:
    git clone http://github.com/baccigalupi/harmony.git
		cd harmony 
		sudo rake install
		
