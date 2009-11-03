#require 'ruby-gems'
require 'test/unit'
require File.join(File.dirname(__FILE__),'..','lib','terminal_styles.rb')
class TerminalStylesTest < Test::Unit::TestCase
  
  def test_basic_styles
    assert_equal "\e[0mPlain text\e[0m", TerminalStyles.cc("Plain text")
  end
  
end