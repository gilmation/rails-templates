# Generic Project Setup

This generic project template is based on (among others) the templates at [DrNic's templates](http://github.com/drnic/rails-templates)

## Dependencies 

 * [Capistrano](http://github.com/jamis/capistrano)
 * [Mysql](http://www.mysql.com)
 * Mysql Gem or equivalent
 * [GIT](http://git-scm.com)

## What you get

 * Plugin / Gem Management with [Cached Externals](git://github.com/37signals/cached_externals.git)
 * [factory\_girl](http://github.com/thoughtbot/factory_girl)
 * [shoulda](http://github.com/thoughtbot/shoulda)
 * [haml](http://haml.hamptoncatlin.com/)
 * [authlogic](http://github.com/binarylogic/authlogic)
 * A default i18n configuration (initializer and yml files) for en-US and es-ES
 * A basic errors initializer
 * Sessions are configured to be stored in the Database
 * A simple ApplicationController
 * Almost the default environment.rb but with vendor/gems/*/lib added to config.load_paths
 * Mysql configuration for development, test, staging and production
 * A sql script to create the DB and Users in mysql
 * A blank README
 * An initial GIT checkin

