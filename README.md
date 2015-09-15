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
    $ bundle install --path=vendor/bundle
    $ npm install
    $ npm run bower

### 4. Run web and app server ###

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
