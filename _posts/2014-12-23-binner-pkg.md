---
layout: post
title: "Introducing the <code>binner</code> package"
categories: code
excerpt: "Reading and scoring AFLP electropherograms in R"
tags: [R, AFLP, reproducible research]
image:
  feature: binner_scanGel.png
date: 2014-12-23
---

It's been more than a year since I posted my first experiments in [reading
ABI `fsa` files in R](http://plantarum.ca/code/abi-part1/). Since that time
I've come up with a complete working solution that allows me to complete
my entire AFLP analysis workflow within R, without resorting to expensive
proprietary programs like GeneMapper or GeneMarker. 

I've tidied up the code and packaged it as `binner`. It's posted on
[github](https://github.com/plantarum/binner), and you can install it
directly using
[Hadley Wickham's `devtools` package](https://github.com/hadley/devtools).

So far I've tested it on only two Debian GNU/Linux installations and one
Windows machine. I'm very curious if it works on other setups. The
graphical bin editor in particular may require some platform-dependent
tweaking.

## Getting started

{% highlight r %}
## Only necessary if you don't already have devtools:
install.packages("devtools")

## Load devtools:
library(devtools)

## Install binner:
install_github("plantarum/binner")

## Load binner:
library(binner)

## Check out the example in the help:
?readFSA
{% endhighlight %}

I haven't put together a vignette, but the help files have a complete
working example -- see `?readFSA` and `?scanGel`.

## Features

1. reading ABI `.fsa` files
1. normalizing electropherograms
1. identifying and sizing peaks
1. viewing individual electropherograms
1. dropping, adding and renaming samples
1. Automated peak-binning, using the RawGeno algorithm
1. Visually editing bins
1. Generating presence-absence matrices for further analysis in R (or
   export for use in other programs, if you like) 


### Reading .fsa files

The first three steps are glued together in the `readFSA` function. The
slowest part of the entire process is calibrating the size standard,
necessary for sizing peaks. I use the algorithm from the `AFLP` package,
slighlty tweaked. The bottleneck occurs in a loop that runs `lm` on various
subsets of potential ladder peaks to determine the best fit. It may be
worth re-implementing this in C. As is, it may take 6-10 minutes to read in
a large (100+) number of `.fsa` files.

It just occured to me that the length of this step is also impacted by the
choice of ladder. Specifically, we use the GS500(-250) ladder. This
standard has a '250' bp peak that you are supposed to ignore (it is usually
closer to 246 bp in my tests). Consequently, the algorithm has to spend
considerable cycles figuring out which peak corresponds to the '250' peak
so it can be excluded. Other standards might give you a slightly faster
processing time, if that's important to you.

`binner` uses the same sizing calculations as the commercial PeakScanner
and GeneMapper programs (i.e., local southern). So other than being
(slightly) slower, it produces near-identical results. (There are slight
differences due to different smoothing parameters.)

![An imported fsa file](/images/binner_readFSA.png)

### Editing bins

The most innovative feature of this package, and the only thing not
currently available in either `AFLP` or `RawGeno`, is a facility for
manually reviewing and editing bin boundaries. The main value of this is in
allowing you to exclude regions where there is no clear division between
bins. The binning algorithm will make a decision, but it's not always
appropriate. With the bin editor, you can decide for yourself if you want
to delete questionable bins, or modify the boundaries manually.

![The `scanGel()` interface](/images/binner_scanGel.png)

## Next steps

There are many possible tweaks to extend the value of `binner` for
processing AFLP data. However, without some external interest they will
probably not get implemented. Our current lab focus is on microsatellites.
As a result, I'm looking at available microsatellite processing options in
R, and will look to extend `binner` in a way to help fill any gaps in
providing a complete workflow within R.
