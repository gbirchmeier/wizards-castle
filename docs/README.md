# wizards-castle documentation

*Wizard's Castle* was originally written by Joseph R. Powers for Exidy Sorcerer Basic
and published in the July 1980 issue of *Recreational Computing Magazine*.

This was later adapted by J.F. Stetson for Heath Microsoft Basic.  More than just a port,
this version made some textual improvements.

This Ruby port is based on the Stetson version, which is the version that I played growing up.
The initial 1.0 release is intended to be as faithful as possible to the Stetson version, with
these exceptions:

1. I can't reproduce the original BASIC "beep" sound, so it just uses your terminal's bell
2. It allows lower-case inputs instead of only caps
3. You can actually scroll up (if your terminal allows)

I have plans for some improvements in post-1.0 versions.  I intend to add options to
enable a few color enhancements, and perhaps to slow the scroll down so your eyes can follow
along through warps/sinkhole chains.

This dir has some other neat docs that may be of interest:

* [castle.txt](castle.txt) - What is displayed when you run `wizards-castle --manual`.
  Aside from the obvious addition about my Ruby port, this is exactly what was distributed
  with J.F. Stetson's version.
* [WIZARD.BAS](WIZARD.BAS) - original J.F. Stetson source (or, the best one I could find).
* [original-article.pdf](original-article.pdf) - This is a scan of the original article
  from *Recreational Computing* magazine (July 1980) where *Wizard's Castle* first premiered.
  `castle.txt` is adapted from this.
* [original-source.pdf](original-code.pdf) - The Joseph R. Powers-authored source code from
  that same article.  (I am unable to find this source in text-file form.)


To see the entire July 1980 issue of *Recreational Computing*, visit   
https://archive.org/details/1980-07-recreational-computing
