# coding: utf-8
lib = File.expand_path('../lib',__FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wizards-castle/version'

Gem::Specification.new do |s|
  s.name        = 'wizards-castle'
  s.version     = WizardsCastle::VERSION
  s.date        = WizardsCastle::VERSION_DATE
  s.summary     = "Explore the Wizard's Castle and seek treasure, defeat monsters, and try to locate the incredible ORB OF ZOT!"
  s.description = <<-EOF
== Wizard's Castle
A Ruby port of a classic BASIC game, this is a text-based adventure
through a randomly-generated castle full of monsters, traps, and
treasure.

The original version was written by Joseph R. Power for
Exidy Sorcerer BASIC and published in the July/August 1980 issue
of Recreational Computing magazine.  It was subsequently ported
to Heath Microsoft Basic by J.F. Stetson.

This Ruby port is based on the Stetson version.

It needs no Gem dependencies to run, and should work on all
2.x versions of Ruby.
EOF
  s.authors     = ["Grant Birchmeier"]
  s.files       = ['bin/wizards-castle'] +
                  Dir['lib/*rb'] +
                  Dir['lib/wizards-castle/*rb'] +
                  Dir['lib/wizards-castle/printers/*rb']
  s.executables = 'wizards-castle'
  s.homepage    = 'http://github.com/gbirchmeier/wizards-castle'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2'
end
