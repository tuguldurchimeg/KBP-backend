#!/usr/bin/env ruby
require 'csv'

csv = CSV.read(File.join('db/fixtures/', Rails.env, '/csv/companies.csv'), headers: true)

csv.each do |role|
  Company.seed_once(:name) do |s|
    s.id = role['id']
    s.uid = role['uid']
    s.name = role['name']
  end
end
