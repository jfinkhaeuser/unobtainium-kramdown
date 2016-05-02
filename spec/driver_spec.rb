# coding: utf-8
#
# unobtainium-kramdown
# https://github.com/jfinkhaeuser/unobtainium-kramdown
#
# Copyright (c) 2016 Jens Finkhaeuser and other unobtainium-kramdown contributors.
# All rights reserved.
#
require 'spec_helper'

describe 'Unobtainium::Kramdown::Driver' do
  it "passes unobtainium's interface checks" do
    expect do
      require 'unobtainium-kramdown'
    end.to_not raise_error(LoadError)
  end

  it "can be created" do
    expect do
      ::Unobtainium::Driver.create(:kramdown)
    end.to_not raise_error

    drv = ::Unobtainium::Driver.create(:kramdown)
    expect(drv).to_not be_nil
  end

  it "opens a file" do
    drv = ::Unobtainium::Driver.create(:kramdown)

    test_uri = "README.md"
    expect { drv.goto(test_uri) }.to_not raise_error
    expect(drv.meta[:uri]).to eql test_uri
  end

  it "opens a web page" do
    drv = ::Unobtainium::Driver.create(:kramdown)

    test_uri = "http://finkhaeuser.de"
    expect { drv.goto(test_uri) }.to_not raise_error
    expect(drv.meta[:uri]).to eql test_uri

    expect(drv.meta[:headers]).not_to be_nil
    expect(drv.meta[:headers]).not_to be_empty
  end

  it "delegates to kramdown" do
    drv = ::Unobtainium::Driver.create(:kramdown)

    test_uri = "README.md"
    expect { drv.goto(test_uri) }.to_not raise_error

    json = nil
    expect { json = drv.to_html }.to_not raise_error

    expect(json).not_to be_nil
    expect(json).not_to be_empty
  end

  #  it "accepts and interprets configuration" do
  #    drv = ::Unobtainium::Driver.create(:kramdown)
  #
  #    drv.parse_method = :XML
  #    drv.options = ::Nokogiri::XML::ParseOptions::STRICT | \
  #                  ::Nokogiri::XML::ParseOptions::PEDANTIC
  #
  #    test_uri = "spec/data/foo.html"
  #    expect { drv.goto(test_uri) }.to raise_error(Nokogiri::XML::SyntaxError)
  #  end
end
