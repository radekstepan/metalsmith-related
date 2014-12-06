{ assert }  = require 'chai'
_           = require 'lodash'

related = do require '../index.js'

module.exports =
  'bulk docs insert': (done) ->
    docs = 
      '1.md': 'contents': 'this document is about node.', 'title': '1'
      '2.md': 'contents': 'this document is about ruby.', 'title': '2'
      '3.md': 'contents': 'this document is about ruby and node.', 'title': '3'
      '4.md': 'contents': 'this document is about node. it has node examples', 'title': '4'
    
    related docs, null, ->

      assert.deepEqual _.pluck(docs['1.md'].related, 'title'), [ '3', '4' ]
      assert.deepEqual _.pluck(docs['2.md'].related, 'title'), [ '3' ]
      assert.deepEqual _.pluck(docs['3.md'].related, 'title'), [ '1', '2', '4' ]
      assert.deepEqual _.pluck(docs['4.md'].related, 'title'), [ '1', '3' ]

      do done