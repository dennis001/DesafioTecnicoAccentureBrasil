require 'rspec'
require 'page-object'
require 'data_magic'
require 'httparty'
require 'pry'
require 'faker'
require 'selenium-webdriver'

BROWSER = (ENV['BROWSER'] || 'chrome').to_sym
HEADLESS = ENV['HEADLESS'] == 'true'

World(PageObject::PageFactory)
