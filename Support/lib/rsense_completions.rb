#!/usr/bin/env ruby

class RSenseCompletions
  attr_reader :cursor, :line, :text, :prefix, :column

  def initialize(cursor = nil, line = nil, text = nil)
    @cursor = cursor || ENV['TM_LINE_INDEX'].to_i
    @line   = line   || ENV['TM_LINE_NUMBER'].to_i
    @text   = text   || ENV['TM_CURRENT_LINE']
    @prefix, @column = find_prefix if @text
  end

  def find_prefix
    column = @text.rindex(".", @cursor) || 0
    prefix = @text[column...@cursor]
    prefix.sub!(/^\./, '')
    prefix.strip!
    [prefix, column]
  end

  def ruby
    ENV["TM_RUBY"] || "ruby"
  end

  def rsense
    "#{ENV['TM_BUNDLE_SUPPORT']}/vendor/rsense/bin/rsense"
  end

  def command(path)
    require "#{ENV['TM_SUPPORT_PATH']}/lib/escape"
    "#{e_sh ruby} #{e_sh rsense} code-completion --file=#{e_sh path} --location=#{@line}:#{@column}"
  end
  
  def rsense_completions
    `#{command}`
  end

  def completion_list
    completions = []
    rsense_completions.each do |comp|
      if comp.match /^completion:\s*(\S+)\s*(\S+)/
        name, full = $1, $2
        completions << [name, full] if name.start_with? prefix or prefix.nil?
      end
    end
    completions.sort.uniq
  end
end
