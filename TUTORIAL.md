# Sample Ruby web-development tutorial

Please expand. `:)`

## Install Sinatra

`gem install sinatra`

## Create your first Sinatra app

Create a `suffragist.rb` file with the following contents:

```Ruby
  require 'sinatra'

  get '/' do
    puts 'Hello, voter!'
  end
```

## Run your app

Run `ruby suffragist.rb` and visit [localhost:4567](http://localhost:4567).

## Add the index view

## Add the results route and the results view

## Factor out a common layout

## Add the ability to POST results

## Persist the results using `YAML::Store`

## Hook the results view to actual results from the YAML file

## See how the YAML file changes when votes are cast
