// (llc, lld) Compiled LLVM binary for multi-platform
const path = require("path");

// TODO libc
const list_os_cpu_bin_p = {
  "android arm64": {
    "llc": "@pm-spl/llc-android-arm64",
    "lld": "@pm-spl/lld-android-arm64",
  },
  "linux arm64": {
    "llc": "@pm-spl/llc-linux-arm64-glibc",
    "lld": "@pm-spl/lld-linux-arm64-glibc",
  },
  "linux riscv64": {
    "llc": "@pm-spl/llc-linux-riscv64-glibc",
    "lld": "@pm-spl/lld-linux-riscv64-glibc",
  },
  "linux x64": {
    "llc": "@pm-spl/llc-linux-x64-glibc",
    "lld": "@pm-spl/lld-linux-x64-glibc",
  },
  "win32 x64": {
    "llc": "@pm-spl/llc-win32-x64",
    "lld": "@pm-spl/lld-win32-x64",
  },
  //
  "wasm": {
    "llc": "@pm-spl/llc-wasm",
    "lld": "@pm-spl/lld-wasm",
  },
};

/// get npm package
function get_p(name) {
  const k = process.platform + " " + process.arch;
  const b = list_os_cpu_bin_p[k];
  if (null != b) {
    const p = b[name];
    if (null != p) {
      return p;
    }
  }

  throw new Error("not support " + name + " " + k);
}

/// get binary path
function bin(name) {
  const p = get_p(name);

  // TODO
  console.log("bin", p);

  const b = path.join(__dirname, "../node_modules", p, "bin", name);
  return b;
}

/// run bin
function run_bin(name) {
  const b = bin(name);

  // TODO
  console.log("run_bin", b);
}

module.exports = {
  bin,
  run_bin,
};
