EPUB Searcher
=============

[![Build Status](https://travis-ci.org/ranguba/epub-searcher.svg?branch=master)](https://travis-ci.org/ranguba/epub-searcher)

A EPUB search Web application based on droonga.

Demo site
---------

http://epub-searcher-demo.kitaitimakoto.net/

Installation
------------

### 1. Install [Droonga][] ###

See [Droonga documentation][] for details.

### 2. Install [Bundler][] ###

    $ [sudo] gem install bundler

### 3. Install EPUB Searcher ###

    $ git clone https://github.com/ranguba/epub-searcher.git path/to/docroot
    $ cd path/to/docroot
    $ bundle install --path=vendor/gems
    $ npm install
    $ npm run bower

### 4. Configure application ###

Make `.env.production` file with content below:

    host=droonga0
    http_server_port=10041

These are definition of environment variables.

Here `droonga0` is the hostname of server which Droonga HTTP Server is running. Ensure that

* you can resolve the hostname to IP address by DNS, `/etc/hosts` or so on in environment EPUB Searcher was installed. Writing IP address as-is is also OK(e.g. `host=10.240.26.26`).
* Droonga HTTP Server binds the IP address resolved from the hostname. Note that it might not be a global IP address, but the one of private network. If EPUB Searcher cannot connect to Droonga, confirm it.

`http_server_port` is the port number that Droonga HTTP Server is listening. If you installed Droonga without explicit configuration, it will `10041` which is the default port of Droonga HTTP Server.

Other lines are written in `.env.development` and `.env.test` in this repository? Don't warry, they're required to run Droonga in development/test environment. Now you have running Droonga in production, those are no longer required.

### 5. Run web and app server ###

EPUB Searcher is a Rack application. There's serveral way to run Rack applications behind web servers, such as Nginx x Puma. It's up to you.

[Droonga]: http://droonga.org/
[Droonga documentation]: http://droonga.org/install/
[Bundler]: http://bundler.io/

Setting development environment up
----------------------------------

    $ git clone https://github.com/ranguba/epub-searcher.git
    $ cd epub-searcher
    $ bundle install --path=vendor/gems
    $ npm install
    $ npm run bower

### Registering EPUB books for development environment ###

    $ ./bin/es-register ./data/test-setup/*.epub another/book.epub

Running droonga components for development
------------------------------------------

    $ bundle exec foreman start --env=.env.development

Running web app server
----------------------

    $ bundle exec padrino start

Running test suite
------------------

Run droonga components for test environment:

    $ bundle exec foreman start --env=.env.test

then run test:

    $ bundle exec rake test

License
-------

GPLv3 or later.
