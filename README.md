# purescript-erl-opentelemetry

An almost 1-1 direct binding to [opentelemetry-erlang](https://github.com/open-telemetry/opentelemetry-erlang) (or at least, the API side of it). (It is assumed the user will run the Erlang SDK and not need any Purerl specific bits for that)

While an attempt has been made to create bindings for almost everything in the API:

- Some functions may be missing (feel free to send a pull request)
- Some functions may not work as intended (feel free to send a pull request)

Some of these bindings are untested statements of intent "this is what it should look like", over time this will cease to be an issue as a greater surface area of this project will either be under test, or in active use in our commercial products.
