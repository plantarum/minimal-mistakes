---
layout: post
title: "Using the LaTeX listings package to style R PDF reports with knitr
and pandoc"
categories: code
excerpt: "Styling your reproducible research reports"
tags: [R, latex, reproducible research]
image:
  feature: daucus.jpg
date: 2014-02-15
---

[knitr][1] is a an R package that allows you to include R code in markdown
or LaTeX source files, and have the code and/or its output included in the
resulting html or pdf files. [RStudio][2] provides good support for this,
so if you want to try it out that's a good place to start. This post
assumes you've got everything installed and working, and want to customize
the pdf output via LaTeX.

 [1]: http://yihui.name/knitr/ "knitr"
 [2]: http://www.rstudio.com/

I've been working with this for a week or two, and the one hitch that I've
run into is generating a nice pdf directly from the source Rmd file. For
example, working from this source file, in the Rmd or R-markdown format:

{% highlight text %}

```{r, include = FALSE}
## setup knitr and display options
library(knitr)
opts_chunk$set(comment=NA)
```

Test document
==

Code with Output
--

Here's a bit of R code:

```{r code-output}
summary(lm(Petal.Length ~ Species, data = iris))
```

By default, the R code and the output it produces are included
in the document.

{% endhighlight %}

Generating html is easy. From within R, just call
`knit2html("example.Rmd")`. This produces a self-contained, nicely
highlighted html file. Even easier from Rstudio, just click the 'knit to
html' button.

Getting to pdf requires one more step. `knit2html("example.Rmd")` created
two new files, one in markdown: `example.md`, and the target html:
`example.html`. The markdown file can be converted to pdf with
`pandoc("example.md", format = "latex")`.

(if you don't need html output, you can use `knit("example.Rmd")` instead
of `knit2html`)

This calls [pandoc][3] behind the scenes to do the conversion. You can now
view your output in a pdf viewer. The R source code and output has a
different font and a bit of highlighting, but are not otherwise set off
from the surrounding code.

 [3]: http://johnmacfarlane.net/pandoc/ "pandoc"


<figure>
<a href="/images/default-pdf.png"><img src="/images/default-pdf.png"></a>
</figure>

I'm preparing R tutorials, and want to visually distinguish my
instructions, the R code, and the associated output. The `pandoc` default
doesn't quite cut it here.

Leaving R for the command line, we can try the `pandoc` `highlight-style`
options. I like `tango`:

{% highlight bash %}
pandoc example.md -o example.pdf --highlight-style=tango
{% endhighlight %}

This shades the R source code, but the output is unchanged. Not quite what I'm after:

<figure>
<a href="/images/tango.png"><img src="/images/tango.png"></a>
</figure>

It seems like the highlight-styles ought to be customizable, but I haven't
figure that out yet.

Pandoc provides one further option, using the LaTeX [Listings package][6].
Listings provides lots of different options for customizing the
presentation and highlighting of code blocks in latex output. With listings
I'll be able to add boxes and shading to the code chunks with a custom
template for the file.

 [6]: http://www.ctan.org/tex-archive/macros/latex2e/contrib/listings/ "Listings Package"

However, before I can do that, I need to fix one small shortcoming of the
Pandoc LaTeX output. When Pandoc uses the `--listings` option on our
`example.md` file:

{% highlight bash %}
pandoc example.md -o example.tex --listings
{% endhighlight %}

The resulting latex is marked up like this:

{% highlight latex %}
begin{lstlisting}[language=R]
summary(lm(Petal.Length ~ Species, data = iris))
end{lstlisting}

begin{lstlisting}

Call:
lm(formula = Petal.Length ~ Species, data = iris)
{% endhighlight %}

Note that the R source code has the language option set to R, but the
output has no options set at all. There's no way to style these two
environments differently in LaTeX. To do that, we need to apply a style to
one or the other of these listings. I haven't found any way to accomplish
this using knitr or pandoc, so I now pipe the pandoc output through sed to
get this done:

{% highlight bash %}
pandoc example.md -o example.tex -s --listings

# add lstlisting style options
sed -i 's/{lstlisting}[language=R]/{lstlisting}[language=R,style=Rcode]/g' 
example.tex
{% endhighlight %}

Almost there. Now the listings styles are applied, but the style needs to
be defined in the document template. Pandoc templates are stored in
`~/.pandoc/templates`. The default latex template is available with the
command `pandoc -D latex`. So I created a new template:

{% highlight bash %}
pandoc -D latex > ~/.pandoc/templates/ty.latex
{% endhighlight %}

Now I can place the listings style info directly into `ty.latex`:

{% highlight latex %}
documentclass[$if(fontsize)$$fontsize$,$endif$$if(lang)$$lang$,$endif$$if(papersize)$$papersize$,$endif$$for(classoption)$$classoption$$sep$,$endfor$]{$documentclass$}
usepackage[T1]{fontenc}
usepackage{tgschola}
usepackage{DejaVuSansMono}                  % monospace font for code
usepackage{amssymb,amsmath}
usepackage{fixltx2e} % provides textsubscript

usepackage[margin=1in]{geometry} % document size
usepackage{natbib}               % reference style
bibpunct{(} {)} {;} {a} {} {,}   % citation formatting

$if(listings)$
usepackage{listings}
usepackage[dvipsnames]{xcolor}
lstset{frame=single,commentstyle=color{BrickRed},columns=fixed,basicstyle=ttfamily,
stringstyle=color{Red},keepspaces=true,showstringspaces=false,
numbers=none}
lstdefinestyle{Rcode}{backgroundcolor=color[gray]{0.95}}
$endif$
{% endhighlight %}

Check the documentation for listings to see all the options. The code here
sets the default options for the R blocks (source and output), including
boxing and colouring strings and comments. In addition, R source code
blocks will be shaded gray; the background of the output remains white.

This is just the head of the file; the rest of it is unchanged from the
default. I don't understand all the options, so I'll leave them alone for
now. I did change the fonts to tgschola for the body, DejaVuSansMono for
the code chunks, and added my standard geometry and natbib options. I
haven't used this template with references yet, so that may need tweaking.

With the template in place, I can now generate a pdf with my preferred
formatting directly from the source Rmd, using the following script:

{% highlight bash %}
Rscript -e 'args <- commandArgs(trailingOnly = TRUE) ; library(knitr) ; knit(args[1])' $fullname
# md -> tex
pandoc $filename.md -o $filename.tex --template=ty --listings
# add lstlisting style options
sed -i 's/{lstlisting}[language=R]/{lstlisting}[language=R,style=Rcode]/g' 
$filename.tex
# tex -> pdf
texi2pdf $filename.tex
{% endhighlight %}

The first line just bundles up the `knitr` call, using `Rscript` to run a
self-contained R session for the processing. Next, we use `pandoc` to
generate the LaTeX file. I use `sed` to add the style options, and finally
call `texi2pdf` to generate the final document.

And here's the result:

{% highlight bash %}
rmd2pdf.sh example.Rmd
{% endhighlight %}

<figure>
<a href="/images/final-knitr-pdf.png"><img src="/images/final-knitr-pdf.png"></a>
</figure>

That's a fairly long and winding path to travel! Now that it's done, I can
use all the features of listings, and only need remember the simple R
Markdown formatting for my day-to-day writing.
