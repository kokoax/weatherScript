require 'mysql'

def get_date(date, client)
  statement = client.query('SELECT YMD FROM daily WHERE YMD = ' + date)
  ret = ''
  statement.each do |index|
    ret = index[0]
  end
  ret
end

def get_large_temp(date, client)
  statement = client.query('SELECT HiLo FROM daily WHERE YMD = ' + date)
  ret = ''
  statement.each do |index|
    ret = index[0].split('/')[0]
  end
  ret
end

def get_small_temp(date, client)
  statement = client.query('SELECT HiLo FROM daily WHERE YMD = ' + date)
  ret = ''
  statement.each do |index|
    ret = index[0].split('/')[1]
  end
  ret
end

def get_precip(date, client)
  statement = client.query('SELECT Precip FROM daily WHERE YMD = ' + date)
  ret = ''
  statement.each do |index|
    ret = index[0]
  end
  ret
end

def get_snow(date, client)
  statement = client.query('SELECT Snow FROM daily WHERE YMD = ' + date)
  ret = ''
  statement.each do |index|
    ret = index[0]
  end
  ret
end

def get_icon_num(date, client)
  statement = client.query('SELECT Icon FROM daily WHERE YMD = ' + date)
  ret = ''
  statement.each do |index|
    ret = index[0]
  end
  ret
end

def get_cond(date, client)
  statement = client.query('SELECT Cond FROM daily WHERE YMD = ' + date)
  ret = ''
  statement.each do |index|
    ret = index[0]
  end
  ret
end

def get_avg_large_temp(date, client)
  statement = client.query('SELECT Avg FROM daily WHERE YMD = ' + date)
  ret = ''
  statement.each do |index|
    ret = index[0].split('/')[0]
  end
  ret
end

def get_avg_small_temp(date, client)
  statement = client.query('SELECT Avg FROM daily WHERE YMD = ' + date)
  ret = ''
  statement.each do |index|
    ret = index[0].split('/')[1]
  end
  ret
end

def main(arg, client)
  now_date = `#{%(date '+%Y%m%d' -d '#{arg[0].delete('-')} days')}`.to_s

  case arg[1]
  when '-day'  then get_date(now_date, client)
  when '-lt'   then get_large_temp(now_date, client)
  when '-st'   then get_small_temp(now_date, client)
  when '-pre'  then get_precip(now_date, client)
  when '-snow' then get_snow(now_date, client)
  when '-i'    then get_icon_num(now_date, client)
  when '-c'    then get_cond(now_date, client)
  when '-alt'  then get_avg_large_temp(now_date, client)
  when '-ast'  then get_avg_small_temp(now_date, client)
  else '-1'
  end
end

client = Mysql.connect('127.0.0.1', 'weather', 'weather', 'weather')

puts(main(ARGV, client))
client.close
