# Simple program to test llc

```sh
pnpm run llc test.ll -mtriple=wasm32 -filetype=obj -O3 -o test.wasm

pnpm run serve
```

<http://localhost:3000/test.html>
