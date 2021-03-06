# encoding: utf-8
#!/usr/bin/env ruby

require 'trello'
# require 'rubygems'
require 'yaml'
require_relative '../lib/trello-archiver'
include Trello
include Trello::Authorization

CONFIG = YAML::load(File.open("config.yml")) unless defined? CONFIG

TrelloArchiver::Authorize.new(CONFIG).authorize

ignore = CONFIG['ignore']

me = Member.find("me")
boardarray = Array.new
me.boards.each do |board|
  if ignore.include? board.id
	  puts "Skipping #{board.name}"
  else
    filename = board.name.parameterize
    # puts "Preparing to backup #{board.name}"
    input = TrelloArchiver::Prompt.new(CONFIG).run
    TrelloArchiver::Archiver.new(:board => board, :filename => filename, :format => input[:format]).create_backup
	end
end
