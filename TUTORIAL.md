# Sample Ruby web-development tutorial

Please expand. `:)`

## Install Sinatra

`gem install sinatra`

coach: explain shortly what is sinatra

## Create your first Sinatra app

Create a `suffragist.rb` file with the following contents:

```Ruby
require 'sinatra'

get '/' do
  'Hello, voter!'
end
```

## Run your app

Got to directory where you put your app and run `ruby suffragist.rb`. Now you can visit [localhost:4567](http://localhost:4567).
You should see “Hello, voter!” page, which means that the generation of your new app worked correctly.
Hit CTRL-C in the terminal to quit the server.

coach: explain post and get methods, and how to communicate with the browser


## Add the index view
To keep everything in order lets make a folder for our views.

Put this code into index.erb
```Ruby
<p>Cast your vote:</p>
<form action='cast' method='post'>
  <ul class='unstyled'>
    <% Choices.each do |id, text| %>
      <li><label class='radio'><input type='radio' name='vote' value='<%= id %>' id='vote_<%= id %>' /> <%= text %></label></li>
    <% end %>
  </ul>
  <button type='submit' class='btn btn-primary'>Cast this vote!</button>
</form>
```
And into suffragist.rb:

```Ruby
Choices = {
  'krk' => 'Cracow',
  'rad' => 'Radom',
  'waw' => 'Warsaw',
  'wro' => 'Wrocław',
}
```

run `ruby suffragist.rb`, check your results and quit server with CTRL-C
Coach: Talk a little about html. Remind loops from previous part of workshop.

## Add the ability to POST results

Put into suffragist.rb:
```Ruby
post '/cast' do
  @vote  = params['vote']
  erb :cast
end
```

Create new view cast.erb and put there some html with embedded ruby code:
```Ruby
<p>You cast: <%= Choices[@vote] %></p>
<p><a href='results'>See the results!</a></p>
```

Coach: Explain what is ERB file.  How to catch what was send in the form? What does @ mean?

## Add the results route and the results view
```Ruby
Put into suffragist.rb:
get '/results' do
  erb :results
end
```

Create new view result.erb

Watch the page (run `ruby suffragist.rb`, check your results and quit server with CTRL-C)

Coach: sum up what we are able to do so far

## Persist the results using `YAML::Store`
Time for something new! Let's store our choices.

Add to suffragist.rb:
```Ruby
require 'yaml/store'
```

Coach: What is YAML?

Add some more code into suffragist.rb:
```Ruby
Replace post '/cast' and get '/results' with code:
post '/cast' do
  @title = 'Thanks for casting your vote!'
  @vote  = params['vote']
  @store = YAML::Store.new 'votes.yml'
  @store.transaction do
    @store['votes'] ||= {}
    @store['votes'][@vote] ||= 0
    @store['votes'][@vote] += 1
  end
  erb :cast
end
```
```Ruby
get '/results' do
  @title = 'Results so far:'
  @store = YAML::Store.new 'votes.yml'
  @votes = @store.transaction { @store['votes'] }
  erb :results
end
```

Coach: Explain why are we using words preceded with @.

Add some code into view with result:
results.erb
```Ruby
<table class='table table-hover table-striped'>
  <% Choices.each do |id, text| %>
    <tr>
      <th><%= text %></th>
      <td><%= @votes[id] || 0 %>
      <td><%= '#' * (@votes[id] || 0) %></td>
    </tr>
  <% end %>
</table>
<p><a href='/'>Cast more votes!</a></p>
```

run `ruby suffragist.rb`& check your results

## Factor out a common layout

## Hook the results view to actual results from the YAML file

## See how the YAML file changes when votes are cast
 Let's open votes.yml. And vote. And check again.


To coaches: There will be situation when one or more of the girls will forget to quit the server before running it again. It's good opportunity to search with girls for google problem. They don't have to know everything about killing processes to find a sollution.
