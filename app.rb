# encoding: utf-8
require 'sinatra'
require 'haml'
require 'sinatra/cookies'
require 'kramdown'

require_relative 'minify_resources'
class Grouptendance < Sinatra::Application
	enable :sessions

	configure :production do
		set :haml, { :ugly=>true }
		set :clean_trace, true
		set :css_files, :blob
		set :js_files,  :blob
		MinifyResources.minify_all
	end

	configure :development do
		set :css_files, MinifyResources::CSS_FILES
		set :js_files,  MinifyResources::JS_FILES
	end

	helpers Sinatra::Cookies
	helpers do
		include Rack::Utils
		alias_method :h, :escape_html
		def markdown(html)
			Kramdown::Document.new(html, coderay_line_numbers:nil, coderay_css: :class).to_html
		end
	end
end

require_relative 'models/init'
require_relative 'routes/init'