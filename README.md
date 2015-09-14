EPUB Searcher
=============

[![Build Status](https://travis-ci.org/ranguba/epub-searcher.svg?branch=master)](https://travis-ci.org/ranguba/epub-searcher)

A EPUB search Web application based on droonga.

Demo site
---------

http://epub-searcher-demo.kitaitimakoto.net/

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
