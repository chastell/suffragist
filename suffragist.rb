require 'sinatra'
require 'yaml/store'

Choices = {
  'krk' => 'Cracow',
  'rad' => 'Radom',
  'waw' => 'Warsaw',
  'wro' => 'Wrocław',
}

get '/' do
  @title = 'Welcome to the Suffragist!'
  erb :index
end

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

__END__

@@ layout
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

@@ index
<p>Cast your vote:</p>
<form action='cast' method='post'>
  <ul class='unstyled'>
    <% Choices.each do |id, text| %>
      <li><label class='radio'><input type='radio' name='vote' value='<%= id %>' id='vote_<%= id %>' /> <%= text %></label></li>
    <% end %>
  </ul>
  <button type='submit' class='btn btn-primary'>Cast this vote!</button>
</form>

@@ cast
<p>You cast: <%= Choices[@vote] %></p>
<p><a href='results'>See the results!</a></p>

@@ results
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
