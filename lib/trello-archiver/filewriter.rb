def createspreadsheet(board, filenamestub="productbacklogbackup", includecomments=true)
  # Filenamestub = filename or default of boardname
  # 
  # Board object has been passed into the method
  lists = board.lists
  FileUtils.mkdir("archive") unless Dir.exists?("archive")
  filename = "archive/#{DateTime.now.strftime "%Y%m%dT%H%M"}_#{filenamestub}.xlsx"
  SimpleXlsx::Serializer.new(filename) do |doc|
    lists.each do |list|
      # logging puts of list name
      puts list.name
      # Gather set of all cards in each list
      cards = list.cards
      # Add workbook based on list name
      doc.add_sheet(list.name) do |sheet|
        # Add header row
        sheet.add_row(%w{Name Description Labels Comments})
        # For each card, dump data in new row
        cards.each do |card|
          require 'pry'; binding.pry
          puts "Title: #{card.name} Desc: #{card.description} List: #{card.list.name} Labels:#{card.labels.length}"
          
          if card.labels.length==0 then labellist = "none" else labellist = "" end
          card.labels.each do |label|
            labellist += " " + label.name
          end

          if includecomments
            # Gather all items from card's timeline, ie all the comments along the way
            actions = card.actions
            commentslist = ""
            actions.each do |action|
              if action.type=="commentCard"
                commentslist += "#{Member.find(action.member_creator_id).full_name} says: #{action.data['text']} \n\n"
              end
            end
          end
          
          # After each of the content items has been created,
          # dump that data into a new row
          sheet.add_row([card.name, card.description, labellist, commentslist])
        end
      end
    end
  end
end