def gem_opt
  defined?(Gem) ? "-rubygems" : ""
end

# --------------------------------------------------
# Tests
# --------------------------------------------------

# new rpsec version
begin 
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new(:spec) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.spec_files = FileList['spec/**/*_spec.rb']
  end
  task :default => :spec
rescue
  task :default => "test:all"
end

# original minitest version
namespace(:test) do
  desc "Run all tests"
  task(:all) do
    exit system("ruby #{gem_opt} -I.:lib:test -e'%w( #{Dir['test/**/*_test.rb'].join(' ')} ).each {|p| require p }'")
  end

  desc "Run all tests on multiple ruby versions (requires rvm)"
  task(:portability) do
    versions = %w(  1.8.6  1.8.7  )
    versions.each do |version|
      system <<-BASH
        bash -c 'source ~/.rvm/scripts/rvm;
                 rvm use #{version};
                 echo "--------- #{version} ----------";
                 rake -s test:all'
      BASH
    end
  end
end

# --------------------------------------------------
# Docs
# --------------------------------------------------
desc "Generate YARD Documentation"
task :yardoc do
  require 'yard'
  YARD::CLI::Yardoc.run *%w( --no-private --no-highlight -o doc/yard --readme README.md --markup markdown - LICENSE )
end

# --------------------------------------------------
# Gem Generation
# --------------------------------------------------
require 'rake/gempackagetask'
require File.dirname( __FILE__ ) + '/lib/harmony'
VERSION = Harmony::VERSION

spec = Gem::Specification.new do |s|
  s.name                = "harmony"
  s.summary             = "Javascript + DOM in your ruby, the simple way"
  s.description         = "Javascript + DOM in your ruby, the simple way. Now more memory sensitive"
  s.author              = "mynyml, baccigalupi"
  s.email               = "mynyml@gmail.com, baccigalupi@gmail.com"
  s.homepage            = "http://github.com/baccigalupi/harmony"
  s.rubyforge_project   = "harmony"
  s.require_path        = "lib"
  s.version             =  Harmony::VERSION
  s.files               =  File.read("Manifest").strip.split("\n")

  s.add_dependency 'johnson', '2.0.0.pre3'
  s.add_dependency 'envjs', '0.3.6'
end


Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

desc "install the gem locally" 
task :install => [:package] do
  sh %{sudo gem install pkg/harmony-#{VERSION}}
end
