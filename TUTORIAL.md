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

To keep everything in order let’s make
a directory for our views (and name it `views`).

Put this code into an `index.erb` file in the `views` directory:

```HTML
<!DOCTYPE html>
<html>
  <head>
    <meta charset='UTF-8' />
    <title>Suffragist</title>
    <link href='//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css' rel='stylesheet' />
  </head>
  <body class='container'>
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
  </body>
</html>
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

Change the `get` action:

```Ruby
get '/' do
  erb :index
end
```

Run `ruby suffragist.rb`, check your
results and quit the server with `ctrl-c`.

Coach: Talk a little about HTML. Explain
templates. Explain what global costants are.



## Templates

Adjust the `index.erb` file in the `views`
directory and add the `<h1>…</h1>` line:

```HTML
…
  <body class='container'>
    <h1><%= @title %></h1>
    <p>Cast your vote:</p>
…
```

Change the `get` action:

```Ruby
get '/' do
  @title = 'Welcome to the Suffragist!'
  erb :index
end
```

Coach: Explain what instance variables are and
how Sinatra makes them visible in the views.



## Add the ability to POST results

Put this into `suffragist.rb`:

```Ruby
post '/cast' do
  @title = 'Thanks for casting your vote!'
  @vote  = params['vote']
  erb :cast
end
```

Create a new file in the `views` directory, `cast.erb`,
and put there some HTML with embedded Ruby code:

```HTML
<!DOCTYPE html>
<html>
  <head>
    <meta charset='UTF-8' />
    <title>Suffragist</title>
    <link href='//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css' rel='stylesheet' />
  </head>
  <body class='container'>
    <h1><%= @title %></h1>
    <p>You cast: <%= Choices[@vote] %></p>
    <p><a href='/results'>See the results!</a></p>
  </body>
</html>
```

Coach: Explain what ERb files are. How to catch
what was sent in the form? What does `@` mean?



## Factor out a common layout

Create `layout.erb` file in the `views` directory. Put there code:

```HTML
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

Remove the above parts from the other two templats
(`index.erb` and `cast.erb` in the `views` directory).
Refresh the page and look into the source code again.

Coach: Talk about structure of the HTML document. Explain what `yield` does.



## Add the results route and the results view

Put this into `suffragist.rb`:

```Ruby
get '/results' do
  erb :results
end
```

Create a new file in the `views` directory, `results.erb`.

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

```HTML
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



## See how the YAML file changes when votes are cast

Let’s open `votes.yml`. And vote. And check again.

Coach: There will be situations when one or more students will
forget to quit the server before running it again. It’s a good
opportunity to search the Internet for a solution. They don’t
have to know everything about killing processes to find a solution.

Coach: In the end explain shortly the differences between Sinatra and Rails.



## Play with the app

Try to change things in the app in any way you see fit:

* Maybe redirect to the results outright?
* Maybe add other votings? How would the YAML file need to change?
* Maybe try to style the file in different ways?
