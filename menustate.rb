class MenuState < Chingu::GameState
  # Expects options hash as an argument.
  # Calls :key_oper method for the selected option (selected with enter or space)
  #
  # Arguments for options hash:
  # :menu_items, array of items for the menu
  # :new_keys, usege similar to self.input=
  # :menu_warp => false, prevent selector warping from top to bottom and vice versa
  def setup( options = {} )
    menu_items = options[:menu_items]
    menu_items = [:back] if menu_items.nil? or menu_items.empty?
    
    new_keys = options[:new_keys]
    new_keys = {} if new_keys.nil?

    options[:menu_warp] == false ? @menu_warp = false : @menu_warp = true
    
    @menu_arr = menu_items
    @oper_hash = {}
    @menu_arr.each_with_index do |sym, i|
      @oper_hash[@menu_arr[i]] = "#{sym.to_s}_oper".to_sym
    end
    @menu_hash = {}
    @selected = 0
    @menu_arr.each_with_index do |menu_key, i|
      menu_object = Chingu::Text.create(:text=>menu_key.to_s.gsub("_"," "), :x=>$window.width/2.2, :y=>$window.height/3 + 30 * i, :size=>30)
      @menu_hash[menu_key] = {:object => menu_object, :operation => @oper_hash[menu_key]}
    end
    item_highlight(@selected)
    self.input = { :return => :select, :space => :space_select, :esc => :escape, :down => :select_down, :up => :select_up }.merge(new_keys)
  end
  
  def method_missing(name, *args)
    super if (/_oper/ =~ name).nil?
    puts "Warning, _oper method is missing. This is probably due to an automatic method call by the menu generator. The missing method was: #{name} with *args: #{args}"
  end
  
  def space_select
    send(@menu_hash[@menu_arr[@selected]][:operation])
  end
  
  def select
    if not $window.text_input
      send(@menu_hash[@menu_arr[@selected]][:operation])
    else
      $window.text_input = nil
    end
  end
  
  def escape
    if not $window.text_input
      back_oper
    else
      $window.text_input = nil
    end
  end
  
  def quit_oper
    $window.close
  end
  
  # :force_setup => forces to run the setup for the old menu when going back
  def back_oper(options={})
    options[:setup] = false unless options.include?(:force_setup)
    pop_game_state(options)
  end
  
  def select_up
    if @selected > 0
      item_normalise(@selected)
      @selected -= 1 
      item_highlight(@selected)
    elsif @selected <= 0 and @menu_warp
      item_normalise(@selected)
      @selected = @menu_arr.length - 1 
      item_highlight(@selected)
    end
  end
  
  def select_down
    if @selected < @menu_arr.length - 1
      item_normalise(@selected)
      @selected += 1
      item_highlight(@selected)
    elsif @selected >= @menu_arr.length - 1 and @menu_warp
      item_normalise(@selected)
      @selected = 0 
      item_highlight(@selected)
    end
  end
  
  def item_highlight(item_number)
    @menu_hash[@menu_arr[item_number]][:object].color = Color::RED
  end
  
  def item_normalise(item_number)
    @menu_hash[@menu_arr[item_number]][:object].color = Color::WHITE
  end
end
