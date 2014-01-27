Grout
-----
-----

Idea
-------

Grout was built to help streamline data retrieval for reporting, and generating
studies for the analytics team at VaynerMedia.

Architecture
---------

Grout uses the Facebook Graph/Insights API to pull both page and post level
data. Every morning, it pulls the last 25 days worth of posts for all brands. It
also pulls daily page level metrics in the morning. At the beginning of the
month, it downloads the last 3 months of data, as to have fresh 3 month rolling
numbers for monthly reports.

Besides pulling data from Facebook, Grout also pulls data from [Stamprr](https://github.com/martinez-angel/stamprr),
a tagging application I built.

REST API
---------

Grout also has a REST API built into the system. The idea here was to create a
robust way to retrieve data without the need for spreadsheets (seriously, f-ck spreadsheets).

Rookie Mistakes
---------------

I know, I know. There's way too many class methods. There are more mistakes
around.  I had a v2 branch I was working on before I left VaynerMedia, but it never got merged with
the MASTER branch. :(

If I had the chance to build it again, I would move all of the HTTP requests
into separate jobs using Sidekiq and Redis. That would help eliminate a bunch of
the code that's supposed to be used for capturing exceptions. I could go on and
on...

Nonetheless, it solved a real business need and saved a buttload of time for the
team.
