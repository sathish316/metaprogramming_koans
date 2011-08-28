#!/usr/bin/env ruby
# -*- ruby -*-

require 'rake/clean'
require 'rake/rdoctask'

SRC_DIR      = 'src'
PROB_DIR     = 'koans'
DIST_DIR     = 'dist'

SRC_FILES = FileList["#{SRC_DIR}/*"]
KOAN_FILES = SRC_FILES.pathmap("#{PROB_DIR}/%f")

today    = Time.now.strftime("%Y-%m-%d")
TAR_FILE = "#{DIST_DIR}/rubykoans-#{today}.tgz"
ZIP_FILE = "#{DIST_DIR}/rubykoans-#{today}.zip"

CLEAN.include("**/*.rbc")
CLOBBER.include(DIST_DIR)

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

module RubyImpls
  # Calculate the list of relevant Ruby implementations.
  def self.find_ruby_impls
    rubys = `rvm list`.gsub(/=>/,'').split(/\n/).sort
    expected.map { |impl|
      last = rubys.grep(Regexp.new(Regexp.quote(impl))).last
      last ? last.split.first : nil
    }.compact
  end

  # Return a (cached) list of relevant Ruby implementations.
  def self.list
    @list ||= find_ruby_impls
  end

  # List of expected ruby implementations.
  def self.expected
    %w(ruby-1.8.6 ruby-1.8.7 ruby-1.9.2 jruby ree)
  end
end

task :default => :walk_the_path

task :walk_the_path do
  cd 'koans'
  ruby 'path_to_enlightenment.rb'
end

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "koans/*.rb")
end

directory DIST_DIR
directory PROB_DIR

file ZIP_FILE => KOAN_FILES + [DIST_DIR] do
  sh "zip #{ZIP_FILE} #{PROB_DIR}/*"
end

file TAR_FILE => KOAN_FILES + [DIST_DIR] do
  sh "tar zcvf #{TAR_FILE} #{PROB_DIR}"
end

desc "Create packaged files for distribution"
task :package => [TAR_FILE, ZIP_FILE]

desc "Upload the package files to the web server"
task :upload => [TAR_FILE, ZIP_FILE] do
  sh "scp #{TAR_FILE} linode:sites/onestepback.org/download"
  sh "scp #{ZIP_FILE} linode:sites/onestepback.org/download"
end

desc "Generate the Koans from the source files from scratch."
task :regen => [:clobber_koans, :gen]

desc "Generate the Koans from the changed source files."
task :gen => KOAN_FILES + [PROB_DIR + "/README.rdoc"]
task :clobber_koans do
  rm_r PROB_DIR
end

file PROB_DIR + "/README.rdoc" => "README.rdoc" do |t|
  cp "README.rdoc", t.name
end

SRC_FILES.each do |koan_src|
  file koan_src.pathmap("#{PROB_DIR}/%f") => [PROB_DIR, koan_src] do |t|
    Koans.make_koan_file koan_src, t.name
  end
end

task :run do
  puts 'koans'
  Dir.chdir("src") do
    puts "in #{Dir.pwd}"
    sh "ruby path_to_enlightenment.rb"
  end
end


desc "Pre-checkin tests (=> run_all)"
task :cruise => :run_all

desc "Run the completed koans againts a list of relevant Ruby Implementations"
task :run_all do
  results = []
  RubyImpls.list.each do |impl|
    puts "=" * 40
    puts "On Ruby #{impl}"
    sh "rvm #{impl} rake run"
    results << [impl, "RAN"]
    puts
  end
  puts "=" * 40
  puts "Summary:"
  puts
  results.each do |impl, res|
    puts "#{impl} => RAN"
  end
  puts
  RubyImpls.expected.each do |requested_impl|
    impl_pattern = Regexp.new(Regexp.quote(requested_impl))
    puts "No Results for #{requested_impl}" unless results.detect { |x| x.first =~ impl_pattern }
  end
end
