EPUB Searcher
=============

[![Build Status](https://travis-ci.org/ranguba/epub-searcher.svg?branch=master)](https://travis-ci.org/ranguba/epub-searcher)

A EPUB search Web application based on droonga.

Setting development environment up
----------------------------------

    $ git clone https://github.com/ranguba/epub-searcher.git
    $ cd epub-searcher
    $ bundle install --path=vendor/gems
    $ npm install

### Registering EPUB books for development environment ###

    $ ./bin/es-register ./data/test-setup/*.epub another/book.epub

Running droonga components for development
------------------------------------------

    $ bundle exec foreman start --env=.env.development

Running web app server
----------------------

    $ bundle exec padrino start
