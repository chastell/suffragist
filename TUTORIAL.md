# Sample Ruby web-development tutorial

This is an example tutorial for teaching web development with Ruby.

## Install Sinatra

`gem install sinatra`

Coach: Explain shortly what [Sinatra](http://www.sinatrarb.com) is.

## Create your first Sinatra app

Create a `suffragist.rb` file with the following contents:

```Ruby
require 'sinatra'

get '/' do
  'Hello, voter!'
end
```

## Run your app

Go to the directory where you put your app and run `ruby suffragist.rb`.
Now you can visit [localhost:4567](http://localhost:4567). You should
see a ‘Hello, voter!’ page, which means that the generation of your new
app worked correctly. Hit `ctrl-c` in the terminal to quit the server.

Coach: Explain POST and GET methods, and how to communicate with the browser.


## Add the index view
To keep everything in order let’s make a folder for our views.

Put this code into `index.erb`:

```ERb
<p>Cast your vote:</p>
<form action='cast' method='post'>
  <ul class='unstyled'>
    <% Choices.each do |id, text| %>
      <li>
        <label class='radio'>
          <input type='radio' name='vote' value='<%= id %>' id='vote_<%= id %>' />
          <%= text %>
        </label>
      </li>
    <% end %>
  </ul>
  <button type='submit' class='btn btn-primary'>Cast this vote!</button>
</form>
```
And into `suffragist.rb`:

```Ruby
Choices = {
  'krk' => 'Cracow',
  'rad' => 'Radom',
  'waw' => 'Warsaw',
  'wro' => 'Wrocław',
}
```

Change get action:
```Ruby
get '/' do
  @title = 'Welcome to the Suffragist!'
  erb :index
end
```

Run `ruby suffragist.rb`, check your
results and quit the server with `ctrl-c`.

Coach: Talk a little about HTML. Recall
loops from the previous part of the workshop.

## Add the ability to POST results

Put this into `suffragist.rb`:

```Ruby
post '/cast' do
  @vote  = params['vote']
  erb :cast
end
```

Create a new view, `cast.erb`, and put
there some HTML with embedded Ruby code:

```ERb
<p>You cast: <%= Choices[@vote] %></p>
<p><a href='results'>See the results!</a></p>
```

Coach: Explain what ERb files are. How to catch
what was sent in the form? What does `@` mean?

## Add the results route and the results view

Put this into `suffragist.rb`:

```Ruby
get '/results' do
  erb :results
end
```

Create a new view, `results.erb`.

Watch the page (run `ruby suffragist.rb`, check
your results and quit the server with `ctrl-c`).

Coach: Sum up what we are able to do so far.

## Persist the results using `YAML::Store`

Time for something new! Let’s store our choices.

Add to `suffragist.rb`:

```Ruby
require 'yaml/store'
```

Coach: What is YAML?

Add some more code into `suffragist.rb` – replace
`post '/cast'` and `get '/results'` with code:

```Ruby
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

get '/results' do
  @title = 'Results so far:'
  @store = YAML::Store.new 'votes.yml'
  @votes = @store.transaction { @store['votes'] }
  erb :results
end
```

Coach: Explain why are we using words preceded with `@`.

Add some code into the `results.erb` view:

```ERb
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

run `ruby suffragist.rb` and check your results.

## Factor out a common layout

Now lets look at the code (right click in the browser and 'view page
source') You can see that there is no head and body tags. We can add
them by adding layout file that will be used in the entire app.

Create layout.erb file in the views directory. Put there code:

```ERb
<!DOCTYPE html>
<html>
  <head>
    <meta charset='UTF-8' />
    <title>Suffragist</title>
    <link href='//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css' rel='stylesheet' />
  </head>
  <body class='container'>
    <h1><%= @title %></h1>
    <%= yield %>
  </body>
</html>
```

Refresh the page and look into source code again.

Coach: Talk about structure of the html document. Tell what 'yield' do

## Hook the results view to actual results from the YAML file

## See how the YAML file changes when votes are cast

Let’s open `votes.yml`. And vote. And check again.

To coaches: There will be situation when one or more student will
forget to quit the server before running it again. It’s a good
opportunity to search the Internet for the problem. They don’t
have to know everything about killing processes to find a solution.

Coach: In the end tell shortly about difference between Sinatra and Rails.
