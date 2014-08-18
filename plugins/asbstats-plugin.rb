require 'cinch'
require_relative '../utils/utils.rb'

class ASBStatsPlugin
  include Cinch::Plugin
  
  match /^(!|@)asbstats (.+)/
  def execute(m, msgtype, poke)
    pokefound = false

    $pokesheet.rows.each do |row|
      if BotUtils.condense_name(row[1]) == BotUtils.condense_name(poke)
        if row[4].length == 0
          BotUtils.msgtype_reply(m, msgtype, "#{row[1]} - #{row[2]} | #{row[3].gsub(", ", "/")} | #{row[5]}/#{row[6]}/#{row[7]}/#{row[8]}/#{row[9]}/#{row[10]} | #{row[11]} BRT | Size: #{row[12]} | Weight: #{row[13]} | +Spe nat. Acc Boost: #{row[14]}% | CC cost: #{row[16]} | #{row[17]} CHP | Sig. Item: #{row[18]} | Boosted Stats: #{row[19]}")
        else
          BotUtils.msgtype_reply(m, msgtype, "#{row[1]} - #{row[2]} | #{row[3].gsub(", ", "/")}/#{row[4]} (H) | #{row[5]}/#{row[6]}/#{row[7]}/#{row[8]}/#{row[9]}/#{row[10]} | #{row[11]} BRT | Size: #{row[12]} | Weight: #{row[13]} | +Spe nat. Acc Boost: #{row[14]}% | CC cost: #{row[16]} | #{row[17]} CHP | Sig. Item: #{row[18]} | Boosted Stats: #{row[19]}")
        end
        pokefound = true
      end
    end
    if pokefound == false
      BotUtils.msgtype_reply(m, msgtype, "Pokemon not found.")
    end    
  end
end