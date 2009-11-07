class TerminalStyles
  MODES = {
    :bold      => 1,
    :underline => 4,
    :flashing  => 5,
    :inverted  => 7
  }
  MODES_KEYS = MODES.keys
  COLOURS = {
    :red      => 31,
    :green    => 32,
    :yellow   => 33,
    :blue     => 34,
    :magenta  => 35,
    :aqua     => 36,
    :white    => 37
  }
  COLOURS_KEYS = COLOURS.keys
  BACKGROUNDS = {
    :bg_red     => 41,
    :bg_green   => 42,
    :bg_yellow  => 43,
    :bg_blue    => 44,
    :bg_magenta => 45,
    :bg_aqua    => 46,
    :bg_white   => 47
  }
  BACKGROUNDS_KEYS = BACKGROUNDS.keys
  
  # TerminalStyles.cc("this is red",:red)
  # TerminalStyles.cc("an important message",:bg_yellow,:white,:bold)
  # TerminalStyles.cc("Full colour set~") { bg(1,3,5) }
  def self.cc(text,*options,&block)
    options.reject! { |opt| opt.nil? }
    
    format = instance_eval(&block) if block_given?
    format = options.first.bind(self).call if options.first.respond_to?(:call)
        
    unless format     
      mode = 0
      colour = nil
      background = nil
      
      options.each do |option|
        if MODES_KEYS.include?(option)
          mode = MODES[option]
          options -= MODES_KEYS
        elsif COLOURS_KEYS.include?(option)
          colour = COLOURS[option]
          options -= COLOURS_KEYS
        elsif BACKGROUNDS_KEYS.include?(option)
          background = BACKGROUNDS[option]
          options -= BACKGROUNDS_KEYS
        end
      end
      
      format = [mode,colour,background].reject { |v| v.nil? }.join(';')
    end
    
    ["\e[",format,'m',text,"\e[0m"].join('')
  end
  
  #1 arg  = greyscale value, 0-15
  #3 args = rgb, 0-6 for each channel
  def self.bg(*opts)
    "48;5;#{parse_opts(opts)}"
  end
  
  def self.fg(*opts)
    "38;5;#{parse_opts(opts)}"
  end
  
  def self.parse_opts(opts)
    if opts.size == 1
      232 + opts.first
    elsif opts.size == 3
      rgb_to_256(*opts)
    else
      raise "dunno what to do with #{opts.inspect}"
    end
  end
  
  #From 256colors.rb
  def self.rgb_to_256(r,g,b)
    r = [r,5].min
    g = [g,5].min
    b = [b,5].min
    16 + (r * 36) + (g * 6) + b 
  end
  
  def self.clear
    "\e[2J"
  end
  
end