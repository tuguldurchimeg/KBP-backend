#!/usr/bin/env ruby
require 'csv'

csv = CSV.read(File.join('db/fixtures/', Rails.env, '/csv/roles.csv'), headers: true)

csv.each do |role|
  Role.seed_once(:name) do |s|
    s.id = role['id']
    s.name = role['name']
    s.description = role['description']
  end
end
