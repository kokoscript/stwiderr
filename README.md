# stwiderr
A tool to pipe output from stderr or stdout to Twitter.

## Usage
`./Stwiderr [-o] <command>`

`command` should be whatever compiler you'd like to run. Ideally, this should be set up as an alias, so something like `gcc` would run `/path/to/Stwiderr gcc` instead.

The `-o` flag tells stwiderr to capture from stdout instead of stderr.

## Building

`haxe build.hxml`

stwiderr interacts with [twurl](https://github.com/twitter/twurl) in order to make requests. Replace the placeholder API key on line 97 before compilation.
