require 'mysql'
require 'open-uri'

def get_weather(month, month_text, year)
  city = `echo $W_CITY`.gsub(/\R/, "")
  url = %(http://slate-dev.accuweather.com/en/jp/#{city}/224170/#{month_text}-weather/224170?monyr=#{month}/1/#{year}&view=table)
  puts( url )

  weather_data = open(url).read
  # puts( weather_data )
  weather_data
end

def split_weather(body)
  tmp = body.scan( /<table cellspacing="0" class="calendar-list">([\s\S]+?)<\/table>/m )
  tmp = body.scan( /<tr(?:[\s\S]*?)>([\s\S]+?)<\/tr>/m )
  word = []
  for index in tmp do
    index = index.join().to_s().gsub( /\R\s*/, "" )
    word.push( index )
  end
  word.join()
end

# Hi / Lo
def update_HiLo(client, data_table, index, update)
  high = data_table[index*5].join().split('/')[0].match( /([0-9]+)/ )[0].to_s()
  low  = data_table[index*5].join().split('/')[1].match( /([0-9]+)/ )[0].to_s()
  request = sprintf( 'UPDATE daily set HiLo = "%s/%s" %s', high, low, update )
  puts(request)
  client.query(request)
end

# Precip
def update_Precip(client, data_table, index, update)
  precip = data_table[index*5+1].join().match( /([0-9]+)/ )[0].to_s()
  request = sprintf('UPDATE daily set Precip = %d %s', precip, update)
  puts(request)
  client.query(request)
end

# Snow
def update_Snow(client, data_table, index, update)
  snow = data_table[index*5+2].join().match( /([0-9]+)/ )[0].to_s()
  request = sprintf('UPDATE daily set Snow = %d %s', snow, update)
  puts(request)
  client.query(request)
end

# icon
def update_Icon(client, data_table, index, update)
  icon = sprintf('%02d', data_table[index*5+3].to_s().match( /([0-9]+)/ )[0].to_i())
  request = sprintf('UPDATE daily set Icon = "%s" %s', icon, update)
  puts(request)
  client.query(request)
end

# cond
def update_Cond(client, data_table, index, update)
  cond = data_table[index*5+3].to_s().match( /<p>(.+)<\/p>/ )[1].to_s()
  request = sprintf('UPDATE daily set Cond = "%s" %s', cond, update)
  puts(request)
  client.query(request)
end

# avg
def update_Avg(client, data_table, index, update)
  avgHigh = data_table[index*5].join().split('/')[0].match( /([0-9]+)/ )[0].to_s()
  avgLow  = data_table[index*5].join().split('/')[1].match( /([0-9]+)/ )[0].to_s()
  request = sprintf('UPDATE daily set Avg = "%s/%s" %s', avgHigh, avgLow, update)
  puts(request)
  client.query(request)
end

def update_database(year, word, day)
  time = word.scan(/<time>(.+?)<\/time>/m)
  td   = word.scan(/<td>(.+?)<\/td>/m)

  client = Mysql::new( '127.0.0.1', 'weather', 'weather', 'weather' )

  time.length().times{ |i|
    if i < day-1 then next end
    date = sprintf('%d%02d%02d', year, time[i].join().split('/')[0], time[i].join().split('/')[1])
    update = 'WHERE YMD = ' + date

    request = sprintf('INSERT INTO daily(YMD) value(%s)', date )
    puts(request)
    begin
      client.query(request)
    rescue Exeption => e
      puts e
    end

    update_HiLo(client, td, i, update)
    update_Precip(client, td, i, update)
    update_Snow(client, td, i, update)
    update_Icon(client, td, i, update)
    update_Cond(client, td, i, update)
    update_Avg(client, td, i, update)
  }
  client.close()
end

def this_month_update()
  day    = `date "+%d"`.to_i().to_s().gsub( /\R/, "" )
  month  = `LC_ALL=C date "+%m"`.to_i().to_s().gsub( /\R/, "" )
  month_text  = `LC_ALL=C date "+%B"`.downcase().gsub( /\R/, "" )
  year   = `date "+%Y"`.to_s().gsub( /\R/, "" )

  body = get_weather(month, month_text, year)
  word = split_weather(body)
  update_database(year, word, day.to_i)
end

def next_month_update()
  month  = `LC_ALL=C date "+%m" -d "1 month"`.to_i().to_s().gsub( /\R/, "" )
  month_text  = `LC_ALL=C date "+%B" -d "1 month"`.downcase().gsub( /\R/, "" )
  year   = `date "+%Y" -d "1 month"`.to_s().gsub( /\R/, "" )

  body = get_weather(month, month_text, year)
  word = split_weather(body)
  update_database(year, word, 1)
end

def main()
  this_month_update()
  next_month_update()
end

main()

