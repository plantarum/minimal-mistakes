---
layout: post
title: "My Own Private Flora of North America"
modified:
categories: botany
excerpt: A first effort in Python web-scraping
tags: []
image:
  feature:
date: 2013-02-23T22:09:22-04:00
---

The [Flora of North America](http://floranorthamerica.org) is a great
resource for botanists. The books are nice, and even better, almost all of
the keys and images are also freely available online. These keys are
generally the best available for a genus or family, unless you're lucky
enough to work in an area with a _very_ recent local flora.

However, since the keys have to include all the species found anywhere in
the US and Canada, they tend to be long and convoluted. On occasion I've
rewritten some of the keys, to trim them down to the species where I live.
This is tedious work, and I usually give up before I've done more than one
or two of my favourite _Carex_ sections.

Enter [Python](http://www.python.org). I've been looking for a good project
to try Python for a while, and it turns out it's a great tool for scraping
websites and reformatting the data to suit your needs.

(If you're not interested in programming, you may want to skip to the end
product, which is my draft
[key to the sedges of Ontario](http://plantarum.ca/botany/). The rest of
this post is about the code I wrote to make it. On the other hand, if you
are interested in Python, what follows may horrify you. It's my first
Python program, so it's bound to be ugly. This may lead you to wonder who
exactly is the intended audience for this post. That's a good question.)

In a nutshell, it works like this:

{% highlight python %}
import fna
## scrape the Eriphorum pages from the site
eriophorum = fna.scrapeTaxon("Eriophorum")
## Turn the data into a key (actually a nested list)
eriophKey = fna.makeKey(eriophorum)
## Extract only the clues that lead to Ontario species
eriophON = fna.selectKey(eriophKey, reg = "Ont.")
## Write your key to a file, formatted for LaTeX
fna.writeLatexKey(eriophON, outfile = "eriophON.tex", 
              title = "\\emph{Eriophorum}", abbrev = "\\emph{E.}~")
{% endhighlight %}

What comes out the other end, in this case saved to the file `eriphON.tex`,
is the FNA key, except with only the species found in Ontario. The actual
output is designed to be used with the
[`dichokey`](http://www.ctan.org/tex-archive/macros/latex/contrib/dichokey)
[`LaTeX`](href="http://www.latex-project.org/) package, so it needs to be
wrapped with appropriate headers and closing tags. I'm collating multiple
keys into a single document, so I have a master file that looks something
like this:

{% highlight latex %}
\documentclass[twocolumn]{article}
\usepackage[landscape,margin=0.75in]{geometry}
\usepackage{dichokey}
\usepackage{gensymb}
\usepackage{tgschola}
\usepackage[T1]{fontenc}

\title{Keys to the Cyperaceae of Ontario}

\begin{document}
\input{eriphON}
\end{document}
{% endhighlight %}

If you aren't familiar with L<sup>a</sup>T<sub>e</sub>X , you can also use
`fna.writeHtmlKey()`. I haven't put much time into that yet, but it does
produce a self-contained html file.

The source code is available from my
[bitbucket repository](https://bitbucket.org/tws/fna/overview "Bitbucket
Repository"). It's a work in progress, and a first effort, so comments and
criticisms are welcome.

A few more comments on things I found interesting:

## Memoizing url requests

The FNA website is kind of slow, and working on a scraper involves sending
a lot of requests. To speed things up, I build a local cache of the
webpages, so only the first request for a webpage goes to the net, all
subsequent calls use the local version:

{% highlight python %}
URLDICT = dict()

def fetchUrl (url, verbose = False) :
    if not url in URLDICT:
        if verbose : print("***fetching from the network***")
        page = urllib2.urlopen(url).read()
        URLDICT[url] = page
    else :
        if verbose : print("***fetching from cache***")
    return(BeautifulSoup(URLDICT[url], "lxml"))
{% endhighlight %}
    
If you want to save the cache at the end of a session, use
`fna.saveDict()`. Reload it with `fna.URLDICT = fna.loadDict()`.
Unfortunately, processing the raw html with Beautiful Soup is also slow,
and there's no straightforward way to save the result to file.

This is called memoization, which I read about in Conrad Barski's fantastic
book <a href="http://landoflisp.com/">Land of Lisp</a>. It's a really
simple trick, and saves a few minutes every time I have to reparse
_Carex_ section _Ovales_ It will be even more useful when
_Crataegus_ goes online, which will hopefully happen later this
year.

## Coping with idiosyncratic formatting

I'm trying to build a general set of tools, but it's challenging because
the FNA is not entirely consistent. Some of the keys contain errors, or are
missing entirely (i.e., _Cyperus_). There are also monotypic genera, and
genera with one or more levels of sub-sectioning. _Carex_ has several
levels of keys above the sectional keys, and then only some of the sections
have proper keys themselves. To deal with this, I use a lower-level
approach to fine-tune the keys I extract. This is the function
`scrapeTaxonDev`, which uses `taxon_id` and, optionally, `key_no`, in place
of the name of the taxon itself. You can find these numbers on the links on
the FNA website. For example, the key to _Carex_ section _Ovales_ west of
the Rockies, which is linked from the main
[section _Ovales_](http://www.efloras.org/florataxon.aspx?flora_id=1&taxon_id=302719),
is
`http://www.efloras.org/florataxon.aspx?flora_id=1&taxon_id=302719&key_no=2`.
So `taxon_id = 302719` and `key_no = 2`.

In addition, both `scrapeTaxon` and `ScrapeTaxonDev` take an optional
`depth` argument. This allows you to tell the scraper how deep to go in the
website before it starts recording names. For example, the _Eleocharis_ key
starts with a key to subgenera. If you call `scrapeTaxon("Eleocharis")` on
its own, the species names come with the subgenus attached.
`scrapeTaxon("Eleocharis", depth = 1)` fixes that.

## Pass by magic

Python doesn't pass arguments like normal languages. It's not pass by
value, and it's not pass by reference. It's something different, referred
to as pass by sharing, or
[call by object](http://effbot.org/zone/call-by-object.htm "Call by
object"). I don't really understand it yet. But it lets you do things like
this:

{% highlight python %}
eleoch = fna.scrapeTaxon("Eleocharis", depth = 1)
eleochKey = fna.makeKey(eleoch)
eleochON = fna.selectKey(eleochKey, reg = "Ont.")
tmp = fna.getLabel(eleochON, label = "3+")
subeleoch = tmp[2]
tmp[2] = fna.endText("subgenus Eleocharis")
{% endhighlight %}

The first three lines prepare the _Eleocharis_ key, as above. Then I
extract the clue with the label `3+` and point the variable `tmp` at it.
Then I point the variable `subeleoch` at the third element of this clue,
which is it's target. Then I point the third element of `tmp` at a new
terminal key text.

After all that, the original `eleochON` is truncated - the target of clue
3+ is now a single text element, rather than a separate branch of the key.
But that branch of the key still exists, and is accessed via `subeleoch`.
This allows me to cut the big _Eleocharis_ key into two pieces, and process
them both separately.

## Moving forward

It's not exactly a work of art, but I find it useful. Excluding _Carex_,
which is a bit tricky with all the sections, and _Cyperus_ which is
missing, I used that code to generate a key to the sedges of Ontario in
about a half-hour. It still needs a bit of personal attention to correct
odd formatting and other minor glitches, but the core information is all
there. _Carex_ is underway, it just requires more hand-coding to deal with
the various sections and nested keys.

This is stage one of my master plan. Stage two is updating the keys to
reflect recent taxonomic work, and more ambitiously, simplifying the keys
beyond the naive truncation that can be done with code. This latter step
will require actual botanical work, rather than weekend hacking. Since I'm
not officially working on sedges at the moment, that may be a slow process.
If anyone wants to contribute ideas, I'd be happy to work them in.

The current key is posted [here](http://plantarum.ca/botany/ "Sedges of
Ontario"), and I'll keep updating it as I work. I hope to have the
Cyperaceae complete by the beginning of the field season (at least,
complete in as much as I have scraped and formatted all the FNA keys -
updating the taxonomy will take longer). I'll continue to update the code
on bitbucket as well. Drop me a line if you find it useful, or want to add
anything.
