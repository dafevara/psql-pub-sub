# frozen_string_literal: true

require 'dotenv'
root = File.dirname(File.absolute_path(__FILE__))
Dotenv.load("#{root}/.env")

require 'bundler'
Bundler.require(:default, ENV['GDB_ENV'])

ActiveRecordMigrations.load_tasks
