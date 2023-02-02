# CringeCompiler
A tool to pipe output from stderr or stdout to Twitter.

## Usage
`./CringeCompiler [-o] <command>`

`command` should be whatever compiler you'd like to run. Ideally, this should be set up as an alias, so something like `gcc` would run `/path/to/CringeCompiler gcc` instead.

The `-o` flag tells CringeCompiler to capture from stdout instead of stderr.

## Building

`haxe build.hxml`

CringeCompiler interacts with [twurl](https://github.com/twitter/twurl) in order to make requests. Replace the placeholder API key on line 97 before compilation.
