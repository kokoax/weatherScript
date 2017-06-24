# Installation
Please execute as root user on mariadb.
- ``MariaDB> CREATE DATABASE weather;``
- ``MariaDB> CREATE TABLE weather.daily(HiLo VARCHAR(8), Precip INT(4), Snow INT(4), Icon VARCHAR(4), Cond VARCHAR(64), Avg VARCHAR(8), YMD INT(8));``
- ``MariaDB> CREATE USER 'weather'@'localhost' IDENTIFIED BY 'weather';``
- ``MariaDB> GRANT select,update ON weather.daily TO 'weather'@'localhost';``

# Usage

## weatherGetter script
The weatherGetter is getting of weather data from accuweather between from this month first to end.
```
$ ruby weatherGetter
```

## weather script
The weather is getting of weather data from database got by the weatherGetter.
```
$ ruby weather -(first option) -(second option)
```

### options

#### first option
- date
```
  -0 is today
  -1 is tomorrow
  -2 ....
```

#### second option
- data's kind
```
  -day  :  day of specific date
  -lt   :  large temprature of specific date
  -st   :  small temprature of specific date
  -pre  :  precip probability of specific date
  -snow :  snow probability of specific date
  -i    :  number of weather icon in site of accuweather of specific date
  -c    :  weather context of specific date
  -alt  :  average large temprature of specific date
  -ast  :  average small temprature of specific date
```

# Example
```
$ ruby weatherGetter
```
When, weather data store to your database(using mysql).
After you exec of
```
$ ruby weather -0 -lt
```
You will getting of today's large temprature
