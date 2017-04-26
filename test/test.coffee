{ assert }  = require 'chai'
_           = require 'lodash'

related = require '../index.js'

docs =
  '1.md': 'contents': 'this document is about node.', 'title': '1'
  '2.md': 'contents': 'this document is about ruby.', 'title': '2'
  '3.md': 'contents': 'this document is about ruby and node.', 'title': '3'
  '4.md': 'contents': 'this document is about node. it has node examples', 'title': '4'

module.exports =
  'get related': (done) ->
    d = _.clone docs, yes

    rel = related {}

    rel d, null, ->
      assert.deepEqual _.map(d['1.md'].related, 'title'), [ '4', '3', '2' ]
      assert.deepEqual _.map(d['2.md'].related, 'title'), [ '3', '4', '1' ]
      assert.deepEqual _.map(d['3.md'].related, 'title'), [ '4', '2', '1' ]
      assert.deepEqual _.map(d['4.md'].related, 'title'), [ '3', '1', '2' ]

      do done

  'threshold': (done) ->
    d = _.clone docs, yes

    rel = related { 'threshold': 1 }

    rel d, null, ->
      assert.deepEqual _.map(d['1.md'].related, 'title'), [ '4', '3' ]
      assert.deepEqual _.map(d['2.md'].related, 'title'), [ '3' ]
      assert.deepEqual _.map(d['3.md'].related, 'title'), [ '4', '2', '1' ]
      assert.deepEqual _.map(d['4.md'].related, 'title'), [ '3', '1' ]

      do done
