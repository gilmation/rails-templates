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
 vendor/plugins/open_id_authentication:
  :type: git 
  :repository: git://github.com/rails/open_id_authentication.git 
  :revision: 079b91f70602814c98d4345e198f743bb56b76b5
 vendor/plugins/authlogic
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
  %q{"en-US":

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

SMTP_SERVER_ERRORS = [TimeoutError,
                      IOError,
                      Net::SMTPUnknownError,
                      Net::SMTPServerBusy,
                      Net::SMTPAuthenticationError]

SMTP_CLIENT_ERRORS = [Net::SMTPFatalError,
                      Net::SMTPSyntaxError]

SMTP_ERRORS = SMTP_SERVER_ERRORS + SMTP_CLIENT_ERRORS
}

# =================
# Create the mysql configuration
# =================
file 'config/database.yml', 
%q{<% PASSWORD_FILE = File.join(RAILS_ROOT, '..', '..', 'shared', 'config', 'dbpassword') %>

development:
  adapter: mysql
  database: <%= PROJECT_NAME %>_development
  username: root
  password: 
  host: localhost
  encoding: utf8
  
test:
  adapter: mysql
  database: <%= PROJECT_NAME %>_test
  username: root
  password: 
  host: localhost
  encoding: utf8
  
staging:
  adapter: mysql
  database: <%= PROJECT_NAME %>_staging
  username: <%= PROJECT_NAME %>
  password: <%= File.read(PASSWORD_FILE).chomp if File.readable? PASSWORD_FILE %>
  host: localhost
  encoding: utf8
  socket: /var/lib/mysql/mysql.sock
  
production:
  adapter: mysql
  database: <%= PROJECT_NAME %>_production
  username: <%= PROJECT_NAME %>
  password: <%= File.read(PASSWORD_FILE).chomp if File.readable? PASSWORD_FILE %>
  host: localhost
  encoding: utf8
  socket: /var/lib/mysql/mysql.sock
}

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
