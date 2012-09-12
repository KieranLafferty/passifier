require 'rubygems'
require 'bundler'
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'passifier'

class Test::Unit::TestCase
end
