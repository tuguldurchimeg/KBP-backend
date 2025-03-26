#!/usr/bin/env ruby
require 'csv'

csv = CSV.read(File.join('db/fixtures/', Rails.env, '/csv/users.csv'), headers: true)

csv.each do |user|
  User.seed_once(:email) do |s|
    s.id = user['id']
    s.uid = user['uid']
    s.email = user['email']
    s.lastname = user['lastname']
    s.firstname = user['firstname']
    s.password = user['password_digest']
    s.role_id = user['role_id']
  end
end
