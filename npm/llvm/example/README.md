# Simple program to test llc

```sh
pnpm exec llc example/test.ll -mtriple=wasm32 -filetype=obj -O3 -o example/test.wasm

pnpm run serve
```

<http://localhost:3000/test.html>
