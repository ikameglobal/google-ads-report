# Stable release

To install <package-name>, run this command in your
terminal:

``` console
pip install <package-name>
```

This is the preferred method to install <package-name>, as it will always install the most recent stable release.

If you don't have [pip][] installed, this [Python installation guide][]
can guide you through the process.

# From source

The source for <package-name> can be downloaded from
the [Github repo][].

You can either clone the public repository:

``` console
git clone git://github.com/<github-username>/<package-name>
```

Or download the [tarball][]:

``` console
curl -OJL https://github.com/<github-username>/<package-name>/tarball/main
```

Once you have a copy of the source, you can install it with:

``` console
pip install .
```

  [pip]: https://pip.pypa.io
  [Python installation guide]: http://docs.python-guide.org/en/latest/starting/installation/
  [Github repo]: https://github.com/<github-username>/<package-name>
  [tarball]: https://github.com/<github-username>/<package-name>/tarball/main
