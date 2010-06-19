#!/usr/bin/env ruby

require "#{ENV['TM_SUPPORT_PATH']}/lib/tm/save_current_document"
require "#{ENV['TM_SUPPORT_PATH']}/lib/ui"

require "#{ENV['TM_BUNDLE_SUPPORT']}/lib/rsense_completions"

TextMate.save_current_document

rsense = RSenseCompletions.new

options = {:case_insensitive => false, :initial_filter => rsense.prefix}
choices = rsense.completion_list(ENV['TM_FILEPATH']).collect do |comp|
  {"display" => comp.first}
end

TextMate::UI.complete(choices, options)
