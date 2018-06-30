#!/usr/bin/ruby
# encoding: utf-8
# Version 1
# 
# full path to image folder
full_image_path = "/Users/kalininalex/Documents/alex-kalinin.github.io/"

require "rubygems"
require "rubypants"

def class_exists?(class_name)
  klass = Module.const_get(class_name)
  return klass.is_a?(Class)
rescue NameError
  return false
end

if class_exists? 'Encoding'
  Encoding.default_external = Encoding::UTF_8 if Encoding.respond_to?('default_external')
  Encoding.default_internal = Encoding::UTF_8 if Encoding.respond_to?('default_internal')
end

begin
  content = STDIN.read.force_encoding('utf-8')
rescue
  content = STDIN.read
end

# Update image urls to point to absolute file path
content = content.gsub(/\{\{sitebaseurl\}\}/, full_image_path)

print(content)