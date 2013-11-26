require 'chingu'
require 'gosu'
require File.expand_path(File.join(File.dirname(__FILE__), 'menustate'))
include Gosu


# An example program utilising MenuState

class Menu < Chingu::Window
  def initialize
    super
    push_game_state(MainMenu)    
    self.input = { :esc => :exit}
  end

end

class MainMenu < MenuState
  
  def setup
    super({ :menu_items => [:start, :options, :quit] })
  end
  
  def start_oper
    puts "start operation!"
  end
  
  def options_oper
    puts "options operation!"
    push_game_state(OptionsMenu)
  end
  
end


# check the options: warp_menu and new_keys from menustate.rb
class OptionsMenu < MenuState
  
  def setup
    super
    super({ :menu_items => [:back, :graphics, :sound]})
    
  end
  
  def graphics_oper
    
  end
  
  def sound_oper
    
  end
  
end

Menu.new.show
