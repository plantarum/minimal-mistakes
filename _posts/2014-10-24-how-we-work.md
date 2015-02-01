---
layout: post
title: "How we work"
categories: research
excerpt: "Rob Denton's work-hacks interview"
tags: [reproducible research, work flow, productivity]
image:
  feature: daucus.jpg
date: 2014-10-24
---

The following interview is my response to
[Rob Denton's "How We Work"](http://rddenton.blogspot.ca/2014/11/how-we-work-dr-tyler-smith-talks.html)
survey.

## Location

Agriculture and Agri-food Canada, Ottawa, Canada

## Current Position

Research Scientist: plant taxonomist

- Taxonomy of native crop wild relatives
- conservation genetics
- plant identification

# One word that best describes how you work
[Inertia](http://rddenton.blogspot.ca/2014/09/how-we-work-dr-paul-hurtado.html)
would work. *Reactive* would be accurate too much of the time as well.
I aspire to be a more *mindful* and *deliberate* in my approach. I struggle
with the bad kind of perfectionism, which can be crippling when you get a
manuscript 90% done. At that point it becomes irresistibly tempting to
start something new, rather than complete something that won't live up to
your aspirations. That's a real productivity killer.

## Current mobile devices
Nexus 5

## Current computer

### 1. Personal Laptop: Debian GNU/Linux on a Thinkpad x201 with 4GB RAM and 320GB HD

### 2. Work Laptop: Debian GNU/Linux on a Standard Issue HP Elitebook

   Both computers run the same operating system with the same suite of
   programs. I sync my important configuration files and documents via
   [BitBucket](http://bitbucket.org).
   
### 3. Digital Ocean Droplet with 512MB RAM, 20GB HD for my website and Owncloud storage 

   If you like tinkering with computers,
   [Digital Ocean](http://digitalocean.com) provides really good value.
   $5/month gets me my own virtual server. So far, other than serving a
   static [Jekyll-generated](http://jekyllrb.com) website, I use it to
   host my OwnCloud instance. [Owncloud](http://owncloud.org) is a
   [Free Software](http://www.fsf.org) replacement for Google Drive or
   Dropbox. It offers the same sort of features, but you control the whole
   system. Nobody is mining it for ad revenue, and I know the owner (me!)
   isn't in cahoots with the NSA or CSEC.

   Another cool thing about Digital Ocean is that you can rent servers by
   the hour. So if you need to do some computationally intensive
   simulations and don't have access to a cluster,
   [you can set one up for a few dollars a day](http://plantarum.ca/code/medium-performance-cluster/),
   and shut it down as soon as you're done.

   I expect I'll eventually install my own version control repositories,
   but until then I use both [BitBucket](http://bitbucket.org) and
   [GitHub](http://github.com). Github is more popular, but BitBucket
   provides unlimited private repositories for free, so all of my
   manuscripts and coding projects go there.

### 4. High-performance clusters for simulation projects and next-gen sequencing projects.

   My post doc was working on
   [spatially-explicit community simulations](http://scholar.google.ca/citations?view_op=view_citation&hl=en&user=LPgEa6UAAAAJ&citation_for_view=LPgEa6UAAAAJ:u-x6o8ySG0sC),
   which introduced me to cluster computing. I'm gearing up to start
   working on next-generation sequencing data, so I'll be putting that
   experience to use as a taxonomist in future.
    
## What apps/software/tools can't you live without?

### 1. [Debian GNU/Linux](http://www.debian.org)

   Debian provides a huge collection of
   [Free Software](http://www.fsf.org), maintained by a chaotic but
   dedicated community of volunteers. Other than the programs I describe
   below, I use the [i3](http://i3wm.org) tiling window manager and spend
   a lot of time in [Bash](http://gnu.org/software/bash) shells.

### 2. [Emacs](http://gnu.org/software/emacs/)

   It's not just a text editor, it's a lifestyle choice. The learning
   curve is steep, but in return you get an infinitely customizable
   workhorse.

### 3. [R](http://www.r-project.org)

   It has its rough spots, but the enormous user/developer community means
   there's very little analysis I need to do that I can't either find a
   package for, or write my own scripts/packages to accomplish. Of course,
   my preferred interface is Emacs, via the
   [ESS](http://ess.r-project.org/) (Emacs Speaks Statistics) add-on. The
   [knitr](http://yihui.name/knitr/) R package provides almost seamless
   integration of data analysis and manuscript preparation.

### 4. [LaTeX](http://www.latex-project.org)

   Writing manuscripts in LaTeX means I get to use the same tools I apply
   to coding (Emacs, version control with [git](http://git-scm.com) or
   [mercurial](http://mercurial.selenic.com/)) to my manuscripts. And the
   integration of code and text in the same document with
   [knitr](http://yihui.name/knitr/) is a game-changing approach to
   organizing manuscripts.

   That said, Emacs and LaTeX are steep hills to climb. A more approachable
   version of the same workflow is using [RStudio](http://www.rstudio.org)
   and [Markdown](http://daringfireball.net/projects/markdown/syntax). When
   I teach R workshops, this is the combination
   [I recommend](http://plantarum.ca/assets/docs/r-markdown.html).

### 5. Distributed Version Control

   [git](http://git-scm.com) is the most popular option, but I find
   [mercurial](http://mercurial.selenic.com/) a little simpler to use.
   Either one provides a very powerful way to track changes in multi-file
   projects, share code with others, and sync files between computers.
   Having just finished collaborating on a manuscript with 'track changes',
   I wish all my peers were using one of these systems.

## What is your best time-saving shortcut/life hack?

For biologists, make your research *Reproducible Research*:

> Reproducible research involves the careful, annotated preservation of
> data, analysis code, and associated files, such that statistical
> procedures, output, and published results can be directly and fully
> replicated

from [ropensci.org](http://ropensci.org/blog/2014/02/20/dvn-dataverse-network/)

This can be a bit overwhelming, as there are a whole ecosystem of tools
available, including text editors, programming languages, development tools
and version control systems. But the pay-off is immense when it comes to
sharing, revising and extending your work.

Other resources:

- [My brief overview](http://plantarum.ca/assets/docs/r-markdown.html)
- [Software Carpentry](http://software-carpentry.org/)
- [Roger Peng](https://www.coursera.org/specialization/jhudatascience/1)

## How do you organize all the stuff you have to do?

I maintain my project outlines and todo lists with the Emacs extension
[org mode](http://orgmode.org). The data is stored as human-readable plain
text files, but with lots of handy features for sorting and prioritizing
tasks, tracking progress and scheduling. I also use it to clock my work on
different tasks (inspired by tweets from Rob), to see if that helps keep my
effort more focused and deliberate. So far I like it, although it takes a
bit of concerted effort to stick with the habit.

## Besides your phone and computer, what gadget can't you live without and why?

In the field, my GPS. An important part of field trip prep is loading it up
with all the [maps](https://www.openstreetmap.org/#map=5/51.500/-0.100) and
herbarium data I need ready access to.

In the office, I love my standing desk. I've had lots of neck, back and arm
issues, and working upright is a big relief. 

## What do you listen to while you work?

Repetitive, atmospheric stuff. Nothing too melodic or lyrical, it needs to
settle into the background. Other than that, I'm pretty eclectic: Persian
sufi music, baroque, Arcade Fire. My current geeky pleasure for coding is
the Tron soundtrack.

## What are you currently reading?

[So good they can't ignore you](http://www.amazon.com/gp/product/1455509124/ref=as_li_qf_sp_asin_il?ie=UTF8&camp=1789&creative=9325&creativeASIN=1455509124&linkCode=as2&tag=stuhac-20).
This is a very contrary approach to building a career. The author argues
strongly against the notion that you should *follow your passion*. His
antidote is to build up a set of rare and valuable skills, and use them
to carve out a rewarding niche for yourself. It's an interesting read,
especially for a scientists considering a career outside academia.

## Are you more of an introvert or an extrovert?

Introvert

## What is your sleep routine like?

Horrible. I don't often get a restful sleep. I'm quite thankful I work in a
job where I can set my own hours. Life was simpler when I was a professor
-- I was so physically exhausted by the workload that I usually collapsed
into sleep at the end of the day!

## What's the best advice you've ever received?

When you feel like you've run up against a brick wall, pause to consider if
getting through it is really what you need to do. I get pretty attached to
my ideas sometimes, and it can be hard to let go of the bad ones.

Also, not so much advice, but my wife is often responsible for getting me
outside in my down time for civilian nature hikes. It's easy to get caught
up in the abstract intellectual side of science. But just experiencing
nature, unburdened by the need to find a target population and acquire more
samples, that's an important way to reinvigorate my work and myself.
