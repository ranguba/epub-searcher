engine: cd db && bundle exec droonga-engine --host=127.0.0.1 --log-file=droonga-engine.log --pid-file=droonga-engine.pid
http-server: export PATH=$PWD/node_modules/.bin:$PATH && cd db && droonga-http-server --receive-host-name=127.0.0.1 --droonga-engine-host-name=localhost --environment=development --cache-size=-1 --pid-file=droonga-http-server.pid
