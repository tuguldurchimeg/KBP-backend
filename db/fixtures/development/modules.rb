#!/usr/bin/env ruby
require 'csv'

csv = CSV.read(File.join('db/fixtures/', Rails.env, '/csv/modules.csv'), headers: true)

csv.each do |mod|
  Base::Module.seed_once(:name) do |s|
    s.id = mod['id']
    s.name = mod['name']
    s.description = mod['description']
  end
end
