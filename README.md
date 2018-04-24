# wizards-castle
[![Gem Version](https://badge.fury.io/rb/wizards-castle.svg)](https://badge.fury.io/rb/wizards-castle)

A Ruby port of the classic BASIC game "Wizard's Castle".

To install, just `gem install wizards-castle`.  It should work fine in any 2.x Ruby,
and has no dependencies on external gems.  It installs the `wizards-castle` script.

To play, just run `wizards-castle`.  Use `--manual` to see the manual,
or `--help` to see more options.

For more info, some historical documents, and the original BASIC source,
see the [docs](docs) directory.


## Bugs!

If you see a crash, please:
* copy the most recent 100+ lines of your game
* note the version you are running

then report those via
* [Github issue](https://github.com/gbirchmeier/wizards-castle/issues)
* Twitter [@GrantBirchmeier](https://twitter.com/GrantBirchmeier)
* email to the address you'll find at http://grantb.net

**Note:** Please do not report in-game grammar errors.  This is a faithful port of
the original game, and the grammar errors are (probably) authentically preserved.


## Development

I'm not really looking for outside contributons or enhancements right now,
but here's notes about hacking on it.

### Running the latest version off of this Git repo

git-clone the repo and run with

    ruby -Ilib ./bin/wizards-castle

As mentioned above, any Ruby 2.x version should work.
For this project, I'm generally using the latest stable 2.x build.

### Tests and Code-checking

I'm using bundler to manage the test gems.

    gem install bundler
    bundle install

To run tests and checks:

    bundle exec rspec
    bundle exec rubocop
