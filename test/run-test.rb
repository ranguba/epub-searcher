#!/usr/bin/env ruby

require 'test-unit'
require 'mocha/setup'

require_relative 'test_config'

exit Test::Unit::AutoRunner.run(true, 'test')
