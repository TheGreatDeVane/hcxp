HCXP
=============================

HCXP is an online hardcore/punk events directory. It synchronizes it's contents with popular social media sites like bandcamp, last.fm or facebook to make life easier for show hosts and to always be up to date.

# Application init

Fork or clone HCXP from Github:

    $ git clone git://github.com/mbajur/hcxp.git

Copy config/database.yml.sample to config/database.yml and fill in your credential.

Then run:

    $ bundle install
    $ rake db:create
    $ rake db:migrate
    $ rake db:seed
    $ rails server

Now, you can access your application in your Web browser at `localhost:3000`.
