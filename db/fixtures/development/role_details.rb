#!/usr/bin/env ruby
require 'csv'

csv = CSV.read(File.join('db/fixtures/', Rails.env, '/csv/role_details.csv'), headers: true)

csv.each do |role|
  Base::RoleDetail.seed_once(:role_id) do |s|
    s.id = role['id']
    s.role_id = role['role_id']
    s.module_id = role['module_id']
    s.action = role['action']
  end
end
