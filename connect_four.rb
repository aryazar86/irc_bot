class Connect_Four

  def initialize
    @connect_four = Array.new(6) { |i| Array.new(7) { |i| "-" }}
    @game_over = false
    @player = true
  end

  def print_array
    puts "1 2 3 4 5 6 7"

    6.times  do |y|
      # print "#{y+1}" + " "
      7.times do |x|
        print @connect_four[y][x] + " "
      end
      puts ""
    end
  end

  def add_a_dot(x)
    if @player == true
      dot = "x"
    else
      dot = "o"
    end

    spot_found = false
    
    5.downto(0) do |y|
      if spot_found == false
        if @connect_four[y][x.to_i-1] == "-"
          @connect_four[y][x.to_i-1] = dot
          spot_found = true
        end
      end
    end
  end

  def check_for_win
    win_horizontal = Array.new
    win_vertical = Array.new
    win_diagonal = Array.new
    6.times do |y|
      7.times do |x|
        if @connect_four[y][x] != "-"
          (0..3).each do |z|
            if x+z <= 6
              win_horizontal << @connect_four[y][x+z]
            end
            if y+z <= 5
              win_vertical << @connect_four[y+z][x]
            end
            if x+z <= 6 && y+z <= 5
              win_diagonal << @connect_four[y+z][x+z]
            end
          end
          if (win_diagonal.length == 4 && win_diagonal.uniq.length == 1) || (win_vertical.length == 4 && win_vertical.uniq.length == 1) || (win_horizontal.length == 4 && win_horizontal.uniq.length == 1)

            if @player == true
              puts "PLAYER 1 WINS!"
            else
              puts "PLAYER 2 WINS!"
            end

            print_array
            @game_over = true
            win_horizontal.clear
            win_vertical.clear
            win_diagonal.clear
          else
            win_horizontal.clear
            win_vertical.clear
            win_diagonal.clear
          end
        end
      end
    end
  end

  def change_player
    if @player == true
      @player = false
    else
      @player = true
    end
  end

  def play

    until @game_over == true do 
      print_array
      if @player == true
        print "Player 1,"
      else
        print "Player 2,"
      end
      print " where do you want to drop a token: "
      add_a_dot(gets.chomp)
      check_for_win
      change_player
    end
  end

end

new_game = Connect_Four.new
new_game.play
