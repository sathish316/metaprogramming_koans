namespace "check" do

  desc "Check that the require files match the about_* files"
  task :abouts do
    about_files = Dir['src/about_*.rb'].size
    about_requires = `grep require src/path_to_enlightenment.rb | wc -l`.to_i
    puts "Checking path_to_enlightenment completeness"
    puts "# of about files:    #{about_files}"
    puts "# of about requires: #{about_requires}"
    if about_files > about_requires
      puts "*** There seems to be requires missing in the path to enlightenment"
    else
      puts "OK"
    end
    puts
  end

  desc "Check that asserts have __ replacements"
  task :asserts do
    puts "Checking for asserts missing the replacement text:"
    begin
      sh "egrep -n 'assert( |_)' src/about_* | egrep -v '__|_n_|project|about_assert' | egrep -v ' *#'"
      puts
      puts "Examine the above lines for missing __ replacements"
    rescue RuntimeError => ex
      puts "OK"
    end
    puts
  end
end

desc "Run some simple consistency checks"
task :check => ["check:abouts", "check:asserts"]
