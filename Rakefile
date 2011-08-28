#!/usr/bin/env ruby
# -*- ruby -*-

require 'rake/clean'

SRC_DIR      = 'src'
KOAN_DIR     = 'koans'

SRC_FILES = FileList["#{SRC_DIR}/*"]
KOAN_FILES = SRC_FILES.pathmap("#{KOAN_DIR}/%f")

module Koans
  # Remove solution info from source
  #   __(a,b)     => __
  #   _n_(number) => __
  #   # __        =>
  def Koans.remove_solution(line)
    line = line.gsub(/\b____\([^\)]+\)/, "____")
    line = line.gsub(/\b___\([^\)]+\)/, "___")
    line = line.gsub(/\b__\([^\)]+\)/, "__")
    line = line.gsub(/\b_n_\([^\)]+\)/, "_n_")
    line = line.gsub(%r(/\#\{__\}/), "/__/")
    line = line.gsub(/\s*#\s*__\s*$/, '')
    line = line.gsub(/assert_equal [\:"']?([\w\s\!']+)['"]?,/, "assert_equal __,")
    line = line.gsub(/assert_match \/(.*?)\//, "assert_match /__/")
    line = line.gsub(/assert_raises(\w+)\//, "assert_raises(___)")
    line = line[line.index('#Write code here'), line.length] if line =~ /#Write code here/
    line
  end

  def Koans.make_koan_file(infile, outfile)
    if infile =~ /edgecase/
      cp infile, outfile
    elsif infile =~ /autotest/
      cp_r infile, outfile
    else
      open(infile) do |ins|
        open(outfile, "w") do |outs|
          state = :copy
          ins.each do |line|
            state = :skip if line =~ /^ *#--/
            case state
            when :copy
              outs.puts remove_solution(line)
            else
              # do nothing
            end
            state = :copy if line =~ /^ *#\+\+/
          end
        end
      end
    end
  end
end

task :default => :walk_the_path

task :walk_the_path do
  cd 'koans'
  ruby 'path_to_enlightenment.rb'
end

task :run do
  puts 'koans'
  Dir.chdir("src") do
    puts "in #{Dir.pwd}"
    sh "ruby path_to_enlightenment.rb"
  end
end

directory KOAN_DIR

desc "Generate the Koans from the source files from scratch."
task :regen => [:clobber_koans, :gen]

desc "Generate the Koans from the changed source files."
task :gen => KOAN_FILES
task :clobber_koans do
  rm_r KOAN_DIR
end

SRC_FILES.each do |koan_src|
  file koan_src.pathmap("#{KOAN_DIR}/%f") => [KOAN_DIR, koan_src] do |t|
    Koans.make_koan_file koan_src, t.name
  end
end