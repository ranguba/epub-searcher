EPUB Searcher
=============

A EPUB search Web application based on droonga.

Setting development environment up
----------------------------------

    $ git clone https://github.com/ranguba/epub-searcher.git
    $ cd epub-searcher
    $ bundle install --path=vendor/gems
    $ npm install

Running droonga components for development
------------------------------------------

    $ bundle exec foreman start

Running web app server
----------------------

    $ bundle exec padrino start
