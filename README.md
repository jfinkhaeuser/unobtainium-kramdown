# unobtainium-kramdown

This gem provides a driver implementation for [unobtainium](https://github.com/jfinkhaeuser/unobtainium)
based on [kramdown](http://www.nokogiri.org/).

[![Gem Version](https://badge.fury.io/rb/unobtainium-kramdown.svg)](https://badge.fury.io/rb/unobtainium-kramdown)
[![Build status](https://travis-ci.org/jfinkhaeuser/unobtainium-kramdown.svg?branch=master)](https://travis-ci.org/jfinkhaeuser/unobtainium-kramdown)
[![Code Climate](https://codeclimate.com/github/jfinkhaeuser/unobtainium-kramdown/badges/gpa.svg)](https://codeclimate.com/github/jfinkhaeuser/unobtainium-kramdown)
[![Test Coverage](https://codeclimate.com/github/jfinkhaeuser/unobtainium-kramdown/badges/coverage.svg)](https://codeclimate.com/github/jfinkhaeuser/unobtainium-kramdown/coverage)

To use it, require it after requiring unobtainium, then create the appropriate driver:

```ruby
require 'unobtainium'
require 'unobtainium-kramdown'

include Unobtainium::World

drv = driver(:kramdown)

# goto is provided by this gem, and wraps `open-uri`. Any URI accepted by that
# will work here.
drv.goto('http://finkhaeuser.de')

# Any other methods are delegated to kramdown, such as e.g. `#to_html`
doc = drv.to_html
```

You probably will not want to parse the output of a converter, though. Use
[drv.root](http://kramdown.gettalong.org/rdoc/Kramdown/Element.html) instead.
