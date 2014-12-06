#metalsmith-related

A [Metalsmith](http://www.metalsmith.io/) plugin that shows related documents for each document in a collection.

![Build Status](http://img.shields.io/codeship/????????????.svg?style=flat)
[![Dependencies](http://img.shields.io/david/radekstepan/metalsmith-related.svg?style=flat)](https://david-dm.org/radekstepan/metalsmith-related)
[![License](http://img.shields.io/badge/license-AGPL--3.0-red.svg?style=flat)](LICENSE)

##Use

```bash
$ npm install metalsmith-related
```

Then in your build script:

```coffeescript
Metalsmith  = require 'metalsmith'
markdown    = require 'metalsmith-markdown'
related     = require 'metalsmith-related'

Metalsmith(__dirname)
.use( related({
  'terms': 5
  'pattern': 'posts/**/*.md'
}) )
.use( do markdown )
.build(do done)
```

You can specify which documents (like posts) will get processed, by providing a [glob](https://github.com/isaacs/minimatch) in the `pattern` option.

The option `terms` defines how many top terms will be used for each document to find its similar documents.

You can now access related documents under the `related` key as an array.

```html
<ul id="posts">
{% for post in related %}
  <li>
    <h2><a href="/{{ post.path }}">{{ post.title }}</a></h2>
    <div class="date">{{ post.date | date('F jS, Y') }}</div>
  </li>
{% endfor %}
</ul>
```

##Source

We depend on the globbing library and [natural's term frequency–inverse document frequency](https://github.com/NaturalNode/natural#tf-idf).

    { Minimatch } = require 'minimatch'
    { TfIdf }     = require 'natural'

    module.exports = (opts) ->
      opts ?= {}

These are the options that you can override, by default we are looking for markdown documents and the top `5` terms.

      opts.pattern ?= '**/*.md'
      opts.terms ?= 5

      mm = new Minimatch opts.pattern

      tfidf = new TfIdf()
      index = []

      (files, metalsmith, done) ->

Save all matching files into the index.

        for key, val of files when mm.match key
          index.push key
          tfidf.addDocument String val.contents

And for each document in the index.

        for i in [ 0...index.length ]

Get the terms sorted by their importance.

          terms = tfidf.listTerms i

Save only the top ones.

          top = ( term for { term } in terms[ 0...Math.min opts.terms, terms.length ] )

Find us similar documents with these terms.

          related = ( files[index[j]] for freq, j in tfidf.tfidfs top when j isnt i and freq > 0 )

And save them under the `related` key.

          files[index[i]].related = related if related.length

All done in sync.

        do done