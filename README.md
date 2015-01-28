# Palisade

**WARNING! Palisade is still under v1.0 development. However, pieces of what
I'd like to be v1.0 are working. This document reflects its current state. Feel
free to use, but use at your own risk.**

## Installation & Configuration

Palisade is a system gem. Install it globally to your system:

```text
$ gem install palisade
```

If you're using `rbenv` or `rvm`, you may need to refresh your `$PATH`. Run
that command, or simply open a new command line session.

We then need to generate a config file:

```text
$ palisade install
```

This will generate a hidden directory -- `.palisade` -- inside your home
directory. The Palisade directory has only one file -- `config.yml`. This is
where you place your backup configuration.

## Usage

Once you are configured, you can run backups from the command line.

```text
$ palisade backup
```

More automated options coming soon.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/palisade/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
