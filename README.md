# usage
## Installation
- create user(id:weather,pass:weather) in mysql
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
  - 0 is today
  - 1 is tomorrow
  - ....
#### second option
- data's kind
  - day   day of specific date
  - lt    large temprature of specific date
  - st    small temprature of specific date
  - pre   precip probability of specific date
  - snow  snow probability of specific date
  - i     number of weather icon in site of accuweather of specific date
  - c     weather context of specific date
  - alt   average large temprature of specific date
  - ast   average small temprature of specific date

# example
```
$ ruby weatherGetter
```
When, weather data store to your database(using mysql).
After you exec of
```
$ ruby weather -0 -lt
```
You will getting of today's large temprature
