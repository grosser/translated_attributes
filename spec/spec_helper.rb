# ---- requirements
require 'rubygems'
require 'spec'
require 'activerecord'

$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

# ---- setup environment/plugin
ActiveRecord::Base.establish_connection({
  :adapter => "sqlite3",
  :database => ":memory:",
})
require 'spec/models'

require File.expand_path("../init", File.dirname(__FILE__))