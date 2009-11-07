require 'test/unit'
require File.join(File.dirname(__FILE__),'..','lib','terminal_styles.rb')
class TerminalStylesTest < Test::Unit::TestCase
  
  def test_basic_styles
    tests = [
      [["Plain text"],                                      "\e[0mPlain text\e[0m"],
      [["Red text",:red],                                   "\e[0;31mRed text\e[0m"],
      [["Red, bold text",:red,:bold],                       "\e[1;31mRed, bold text\e[0m"],
      [["Blue text with red background",:blue,:bg_red],     "\e[0;34;41mBlue text with red background\e[0m"],
      [["Conflicting colours, last value wins",:red,:blue], "\e[0;34mConflicting colours, last value wins\e[0m"],
      [["Flashing red text",:red,:flashing],                "\e[5;31mFlashing red text\e[0m"],
      [["Inverted text",:inverted],                         "\e[7mInverted text\e[0m"],
      [["Aqua, inverted text",:aqua,:inverted],             "\e[7;36mAqua, inverted text\e[0m"],
      [["Full greyscale",proc { fg(10) }],                  "\e[38;5;242mFull greyscale\e[0m"],
      [["Pink-ish",proc { fg(5,1,5) }],                     "\e[38;5;207mPink-ish\e[0m"],
      [["Creamy background",proc { bg(4,4,2) }],            "\e[48;5;186mCreamy background\e[0m"]
    ]
    
    tests.each do |test_values|
      args,expected = *test_values
      block = args.pop if args.last.is_a?(Proc)
      test_name = args.first
      output = TerminalStyles.style(*args,&block)
      puts output if $VERBOSE
      assert_equal expected, output, "#{test_name} failed"
    end
  end
  
end