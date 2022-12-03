# encoding: utf-8
require 'sequel'
DB = Sequel.connect 'sqlite://models/db.sqlite3'

require_relative 'event'