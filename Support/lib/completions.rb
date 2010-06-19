#!/usr/bin/env ruby

require "#{ENV['TM_SUPPORT_PATH']}/lib/ui"

require "#{ENV['TM_BUNDLE_SUPPORT']}/lib/rsense_completions"

rsense = RSenseCompletions.new

choices = rsense.completion_list.map{|m| {"display" => "#{m[0]}"}}
options = {:case_insensitive => false, :initial_filter => rsense.prefix}

TextMate::UI.complete(choices, options)
