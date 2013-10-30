require "socket"


module Parse_String

  def find_user(string, irc_server)
    username = string[0..string.index("!")]
    puts "Am in find user and the username is #{username}"
    return username
  end

end

server = "chat.freenode.net"
port = "6667"
nick = "ZC4bot"
channel = "#connectfourchannel"
greeting_prefix = "privmsg #{channel} :"
# greetings = ["hello", "hi", "hola", "yo", "wazup", "guten tag", "howdy", "salutations", "who the hell are you?"]

irc_server = TCPSocket.open(server, port)

irc_server.puts "USER bhellobot 0 * BHelloBot"
irc_server.puts "NICK #{nick}"
irc_server.puts "JOIN #{channel}"
irc_server.puts "PRIVMSG #{channel} :To play Connect Four, type play "

class Connect_Four

  include Parse_String

  def initialize(irc_server, channel, username)
    @connect_four = Array.new(6) { |i| Array.new(7) { |i| "-" }}
    @game_over = false
    @player = true
    @irc_server = irc_server
    @channel = channel
    @username = username
  end

  def print_array
    @irc_server.puts "PRIVMSG #{@channel} :1 2 3 4 5 6 7"
    string = ""
    6.times  do |y|
      # irc_server.puts "#{y+1}" + " "
      7.times do |x|
        string << @connect_four[y][x] + " "
      end
      @irc_server.puts "PRIVMSG #{@channel} :#{string}\n"
      string = ""
    end
  end

  def add_a_dot(string)
    
    move = string[string.index("move:").to_i + 5]
    puts string
    puts move

    if @player == true
      dot = "x"
    else
      dot = "o"
    end

    spot_found = false
    
    5.downto(0) do |y|
      if spot_found == false
        if @connect_four[y][move.to_i-1] == "-"
          @connect_four[y][move.to_i-1] = dot
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

            if player == true
              @irc_server.puts "PRIVMSG #{@channel} :PLAYER 1 WINS!"
            else
              @irc_server.puts "PRIVMSG #{@channel} :PLAYER 2 WINS!"
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
      puts "Username is: #{@username}"
      string = "" 
      print_array
      @irc_server.puts "PRIVMSG #{@channel} :Where do you want to drop a token?"
      if (@irc_server.gets).include?(@username)
        puts "HERE"
        add_a_dot(string)
      end
      check_for_win
      change_player
    end
  end

end

include Parse_String

until irc_server.eof? do
  msg = irc_server.gets.downcase
  puts msg

  if msg.include?("play")
    new_game = Connect_Four.new(irc_server, channel, find_user(msg, irc_server))
    new_game.play
  end
end
