engine: cd db && bundle exec droonga-engine --host=$host --port=$engine_port --log-file=droonga-engine.log --pid-file=droonga-engine.pid
http-server: cd db && $(npm bin)/droonga-http-server --receive-host-name=$host --port=$http_server_port --droonga-engine-host-name=$host --droonga-engine-port=$engine_port --environment=development --cache-size=-1 --pid-file=droonga-http-server.pid
