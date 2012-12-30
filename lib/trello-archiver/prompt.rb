module TrelloArchiver

  class Prompt
    include Trello
    include Trello::Authorization

    def initialize(config)
      @config = config
    end

    def get_board

      me = Member.find("me")
      boardarray = Array.new
      optionnum = 1
      me.boards.each do |board|
        boardarray << board
        puts "#{optionnum}: #{board.name} #{board.id}"
        optionnum += 1
      end

      puts "0 - CANCEL\n\n"
      puts "Which board would you like to backup?"
      if @config['board'].nil?
        board_to_archive = gets.to_i - 1
      else
        board_to_archive = @config['board'] - 1
      end

      if board_to_archive == -1
         puts "Cancelling"
         exit 1
      end

      board = Board.find(boardarray[board_to_archive].id)
    end

    def get_filename

      puts "Would you like to provide a filename? (y/n)"

      if @config['filename'] == 'default'
        filename = @board.name.parameterize
      else
        response = gets.downcase.chomp
         if response.to_s =~ /^y/i
           puts "Enter filename:"
           filename = gets.chomp
         else
           filename = @board.name.parameterize
         end
      end


        puts "Preparing to backup #{@board.name}"
        lists = @board.lists
        filename
    end

    def run
      @board = get_board
      @filename = get_filename
      result = {}
      result[:board] = @board
      result[:filename] = @filename
      result
    end

  end
end
