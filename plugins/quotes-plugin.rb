# The original script is made by Caitlin Woodward
# This is a modified version made to work with Github Gists
# original repo here: https://github.com/caitlin/cinch-quotes

require 'cinch'
require 'open-uri'

class QuotesPlugin
  include Cinch::Plugin

  match /!addquote (.+)/i,  method: :addquote
  match /!quote (.+)/i,     method: :quote
  match "!quote",           method: :quote

  def initialize(*args)
    super

    @quotes_address = config[:quotes_address]
  end

  def addquote(m, quote)
    # make the quote
    new_quote = { "quote" => quote, "added_by" => m.user.nick, "created_at" => Time.now, "deleted" => false }

    # add it to the list
    existing_quotes = get_quotes || []
    existing_quotes << new_quote

    # find the id of the new quote and set it based on where it was placed in the quote list
    new_quote_index = existing_quotes.index(new_quote)
    existing_quotes[new_quote_index]["id"] = new_quote_index + 1

    # write it to the file
    Gist.gist(existing_quotes.to_s, :update => @quotes_address, :filename => 'quotes.rb')

    # send reply that quote was added
    m.reply "#{m.user.nick}: Quote successfully added as ##{new_quote_index + 1}."
  end

  def quote(m, search = nil)
    puts "BEGINNING QUOTE SEARCH"
    quotes = get_quotes.delete_if{ |q| q["deleted"] == true }
    puts "THE QUOTES ARE #{quotes}"
    if search.nil? # we are pulling random
      puts "PULLING RANDOM"
      quote = quotes.sample
      m.reply "#{m.user.nick}: ##{quote["id"]} - #{quote["quote"]}"
    elsif search.to_i != 0 # then we are searching by id
      puts "SEARCHING BY ID"
      quote = quotes.find{|q| q["id"] == search.to_i }
      if quote.nil?
        m.reply "#{m.user.nick}: No quotes found."
      else 
        m.reply "#{m.user.nick}: ##{quote["id"]} - #{quote["quote"]}"
      end
    else 
      puts "SEARCHING BY NAME"
      quotes.keep_if{ |q| q["quote"].downcase.include?(search.downcase) }
      if quotes.empty?
        m.reply "#{m.user.nick}: No quotes found."
      else
        quote = quotes.sample
      end
    end
  end

  #--------------------------------------------------------------------------------
  # Protected
  #--------------------------------------------------------------------------------
  
  protected

  def get_quotes
    quotes = eval(open(Gist.rawify(@quotes_address)).read)
  end

end