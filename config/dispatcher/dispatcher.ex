defmodule Dispatcher do
  use Matcher

  define_accept_types [
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ],
  ]

  @any %{}
  @json %{ accept: %{ json: true } }
  @html %{ accept: %{ html: true } }

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule.
  #
  # docker-compose stop; docker-compose rm; docker-compose up
  # after altering this file.
  #
  # match "/themes/*path", @json do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end

  get "/sync/deltas/files/*path" do
    Proxy.forward conn, path, "http://delta-producer-json-diff-file-publisher-physical-files/files/"
  end

  get "/files/:id/download" do
    Proxy.forward conn, [], "http://file/files/" <> id <> "/download"
  end

  post "/files/*path" do
    forward conn, path, "http://file/files/"
  end

  delete "/files/*path" do
    forward conn, path, "http://file/files/"
  end

  match "/files/*path" do
    Proxy.forward conn, path, "http://resource/files/"
  end

  match "_", %{ last_call: true } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
