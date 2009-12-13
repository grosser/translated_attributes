# ---- requirements
require 'rubygems'
require 'spec'
require 'active_record'

$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

# ---- setup environment/plugin
ActiveRecord::Base.establish_connection({
  :adapter => "sqlite3",
  :database => ":memory:",
})

#ActiveRecord::Base.logger = Logger.new(STDOUT)

require File.expand_path("../init", File.dirname(__FILE__))

require 'spec/models'