# =================
# Plugins
# =================

plugin 'cached_externals', :git => "git://github.com/37signals/cached_externals.git"

# =================
# Gems - Application
# =================

gem 'ruby-openid'

# =================
# Gems - Generators
# =================

gem 'nifty-generators'

# =================
# Gems - Testing
# =================

gem 'mocha'
gem 'thoughtbot-factory_girl'
gem 'thoughtbot-shoulda'

# =================
# Gems - Control the versions of the Gems
# =================

# freeze!
# rake("gems:install", :sudo => true)
# rake("gems:unpack")

# =================
# Set up Capistrano and Cached Externals 
# =================

#Create cap file
capify!

#Create config/externals.yml
file "config/externals.yml", <<-END
vendor/plugins/prawnto:
  :type: git
  :repository: git://github.com/thorny-sun/prawnto.git
  :revision: b17bf52025e58b2ee74aeaa72d365f2dcc780f8a
vendor/rails:
  :type: git
  :repository: git://github.com/rails/rails.git
  :revision: v2.3.2.1
vendor/plugins/haml:
  :type: git 
  :repository: git://github.com/nex3/haml.git
  :revision: 2.0.9
vendor/plugins/calendar_date_select:
  :type: git 
  :repository: git://github.com/timcharper/calendar_date_select.git
  :revision: 88b7caf7acecf31186661c0efd6bc606cdcc666d
vendor/plugins/safe_mass_assignment:
  :type: git 
  :repository: git://github.com/jamis/safe_mass_assignment.git
  :revision: 7d7e24e551254e0651f5cfb93d876beaed9ed7f7
vendor/plugins/project_search:
  :type: git 
  :repository: git://github.com/37signals/project_search.git
  :revision: 5d243711fbbd69ac08ba86418316bd15cffa0642
vendor/plugins/authlogic:
  :type: git 
  :repository: git://github.com/binarylogic/authlogic.git
  :revision: v2.0.13
END

# =================
# ActionMailer - Initializer
# =================
# initializer 'action_mailer_configs.rb', 
# %q{ActionMailer::Base.smtp_settings = {
#    :address => "smtp.domain.com",
#     :port    => 25,
#     :domain  => "domain.com"
# }
# }

# =================
# i18n - Initializer, English and Spanish initial values
# =================

initializer 'i18n.rb', 
%q{I18n.default_locale = 'en-US'
LOCALES_DIRECTORY = "#{RAILS_ROOT}/config/locales/"
LANGUAGES = {
  'English' => 'en-US' ,
  "Español" => 'es-ES'
}
}

file "config/locales/en-US.yml", 
  %q{"en-US":

  activerecord:
    errors:
      template:
        header: "Error"
        body: ""

  common:
    name: "Name"
    group: "Group"
    active: "Active"
    edit: "Edit"
    delete: "Delete"
    save: "Save"
    back: "Back"
    view: "View"
    sure: "Are you sure?"
    description: "Description"
    all: "All"
    yes: "Yes"
    no: "No"
    reportGenerado: "Report Generated"
    generatePdf: "Generate Pdf"
}

file "config/locales/es-ES.yml", 
  %q{"en-ES":

  activerecord:
    errors:
      template:
        header: "Error"
        body: ""

  common:
    name: "Nombre"
    group: "Grupo"
    active: "Activo"
    edit: "Editar"
    delete: "Borrar"
    save: "Grabar"
    back: "Volver"
    view: "Mostrat"
    sure: "Estás seguro?"
    description: "Descripcion"
    all: "Todos"
    yes: "Si"
    no: "No"
    reportGenerado: "Informe Generado"
    generatePdf: "Pdf Generado"
}

# =================
# errors - Initializer
# =================
initializer 'errors.rb', 
%q{# Example:
#   begin
#     some http call
#   rescue *HTTP_ERRORS => error
#     do something !
#   end

HTTP_ERRORS = [Timeout::Error,
               Errno::EINVAL,
               Errno::ECONNRESET,
               EOFError,
               Net::HTTPBadResponse,
               Net::HTTPHeaderSyntaxError,
               Net::ProtocolError]

#SMTP_SERVER_ERRORS = [TimeoutError,
#                      IOError,
#                      Net::SMTPUnknownError,
#                      Net::SMTPServerBusy,
#                      Net::SMTPAuthenticationError]

#SMTP_CLIENT_ERRORS = [Net::SMTPFatalError,
#                      Net::SMTPSyntaxError]

#SMTP_ERRORS = SMTP_SERVER_ERRORS + SMTP_CLIENT_ERRORS
}

# =================
# Sessions - Initializer
# =================
initializer 'session_store.rb', <<-EOS.gsub(/^  /, '')
  ActionController::Base.session = { :session_key => '_#{(1..6).map { |x| (65 + rand(26)).chr }.join}_session', :secret => '#{(1..40).map { |x| (65 + rand(26)).chr }.join}' }
  ActionController::Base.session_store = :active_record_store
  EOS

# =================
# Create the rails configuration - environment.rb
# =================
file 'app/controllers/application_controller.rb', 
%q{class ApplicationController < ActionController::Base

  helper :all

  layout "application"

  protect_from_forgery

  filter_parameter_logging :password

end
}

# =================
# Create the rails configuration - environment.rb
# =================
file 'config/environment.rb', 
%q{# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  
  # Add the vendor/gems/*/lib directories to the LOAD_PATH
  config.load_paths += Dir.glob(File.join(RAILS_ROOT, 'vendor', 'gems', '*', 'lib'))
  
  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # The internationalization framework can be changed to have another default locale (standard is :en) or more load paths.
  # All files from config/locales/*.rb,yml are added automatically.
  # config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :en

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # Please note that observers generated using script/generate observer need to have an _observer suffix
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
end
}

# =================
# Create the mysql configuration
# =================
file("config/database.yml") do

  @project_name_db = ask("What's the name of the project? (used to create databases for development, test, staging and production)")
  @staging_password = ask("What's the staging password?") 
  @production_password = ask("What's the production password?") 

  database_yml = "development:\n"
  database_yml<<"  adapter: mysql\n"
  database_yml<<"  database: #{@project_name_db}_development\n"
  database_yml<<"  username: #{@project_name_db}_admin\n"
  database_yml<<"  password: #{@project_name_db}_admin\n"
  database_yml<<"  host: localhost\n"
  database_yml<<"  encoding: utf8\n"
  database_yml<<"  socket: /tmp/mysql.sock\n"
  database_yml<<"  pool: 5\n"
  
database_yml<<"test:\n"
  database_yml<<"  adapter: mysql\n"
  database_yml<<"  database: #{@project_name_db}_test\n"
  database_yml<<"  username: #{@project_name_db}_admin\n"
  database_yml<<"  password: #{@project_name_db}_admin\n"
  database_yml<<"  host: localhost\n"
  database_yml<<"  encoding: utf8\n"
  database_yml<<"  socket: /tmp/mysql.sock\n"
  database_yml<<"  pool: 5\n"
  
database_yml<<"staging:\n"
  database_yml<<"  adapter: mysql\n"
  database_yml<<"  database: #{@project_name_db}_staging\n"
  database_yml<<"  username: #{@project_name_db}\n"
  database_yml<<"  password: #{@staging_password}\n"
  database_yml<<"  host: localhost\n"
  database_yml<<"  encoding: utf8\n"
  database_yml<<"  socket: /tmp/mysql.sock\n"
  database_yml<<"  pool: 5\n"
  
database_yml<<"production:\n"
  database_yml<<"  adapter: mysql\n"
  database_yml<<"  database: #{@project_name_db}_production\n"
  database_yml<<"  username: #{@project_name_db}\n"
  database_yml<<"  password: #{@production_password}\n"
  database_yml<<"  host: localhost\n"
  database_yml<<"  encoding: utf8\n"
  database_yml<<"  socket: /tmp/mysql.sock\n"
  database_yml<<"  pool: 5\n"
  
  database_yml
end

# =================
# Create a script to create databases and users
# =================
file("db/scripts/createDatabaseUsers.sql") do

  createDatabaseUsersString = "CREATE DATABASE #{@project_name_db}_development character set utf8;\n"
  createDatabaseUsersString<<"GRANT ALL PRIVILEGES ON #{@project_name_db}_development.* to '#{@project_name_db}_admin'@'localhost' IDENTIFIED BY '#{@project_name_db}_admin' WITH GRANT OPTION;\n"
  createDatabaseUsersString<<"GRANT SELECT, INSERT, UPDATE, DELETE ON #{@project_name_db}_development.* to '#{@project_name_db}'@'localhost' IDENTIFIED BY '#{@project_name_db}' WITH GRANT OPTION;\n\n"

  createDatabaseUsersString<<"CREATE DATABASE #{@project_name_db}_test character set utf8;\n"
  createDatabaseUsersString<<"GRANT ALL PRIVILEGES ON #{@project_name_db}_test.* to '#{@project_name_db}_admin'@'localhost' IDENTIFIED BY '#{@project_name_db}_admin' WITH GRANT OPTION;\n"
  createDatabaseUsersString<<"GRANT SELECT, INSERT, UPDATE, DELETE ON #{@project_name_db}_test.* to '#{@project_name_db}'@'localhost' IDENTIFIED BY '#{@project_name_db}' WITH GRANT OPTION;\n\n"

  if(yes?("Do you want to script the creation of the staging database?")) then
    createDatabaseUsersString<<"-- Staging\n"
    createDatabaseUsersString<<"CREATE DATABASE #{@project_name_db}_staging character set utf8;\n"
    createDatabaseUsersString<<"GRANT ALL PRIVILEGES ON #{@project_name_db}_staging.* to '#{@project_name_db}_admin'@'localhost' IDENTIFIED BY '#{@project_name_db}_admin' WITH GRANT OPTION;\n"
    createDatabaseUsersString<<"GRANT SELECT, INSERT, UPDATE, DELETE ON #{@project_name_db}_staging.* to '#{@project_name_db}'@'localhost' IDENTIFIED BY '#{@staging_password}' WITH GRANT OPTION;\n\n"
  end

  if(yes?("Do you want to script the creation of the production database?")) then
    createDatabaseUsersString<<"-- Production\n"
    createDatabaseUsersString<<"CREATE DATABASE #{@project_name_db}_production character set utf8;\n"
    createDatabaseUsersString<<"GRANT ALL PRIVILEGES ON #{@project_name_db}_production.* to '#{@project_name_db}Admin'@'localhost' IDENTIFIED BY '#{@project_name_db}_admin' WITH GRANT OPTION;\n"
    createDatabaseUsersString<<"GRANT SELECT, INSERT, UPDATE, DELETE ON #{@project_name_db}_production.* to '#{@project_name_db}'@'localhost' IDENTIFIED BY '#{@production_password}' WITH GRANT OPTION;"
  end 
  createDatabaseUsersString
end

# =================
# Create a blank README
# =================
run "echo 'TODO add readme content' > README"

# =================
# Delete "Extra" files
# =================
run "rm public/index.html"

# =================
# Set up the project in git
# =================
git :init

#Create empty .gitignore files
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

# Set up the cached_externals
run "cap local externals:setup"

# Add everything to git
git :add => "."
git :commit => "-m 'initial commit'"

# Set up sessions
#  rake 'db:create'
rake("db:sessions:create")

run "echo 'Use the script in db/scripts to create the database manually'"
run "echo 'Then run - rake db:migrate'"
