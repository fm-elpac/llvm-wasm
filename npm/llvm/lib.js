// (llc, lld) Compiled LLVM binary for multi-platform
const path = require("path");
const cp = require("child_process");

const resolvePkg = require("resolve-pkg").default;

const list_os_cpu_bin_p = {
  "android arm64": {
    "llc": "@pm-spl/llc-android-arm64",
    "lld": "@pm-spl/lld-android-arm64",
  },
  // TODO libc
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
  // TODO
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
  const r = resolvePkg(p, { cwd: __dirname });

  if (null != r) {
    const b = path.join(r, "bin", name);
    return b;
  }

  throw new Error("not found package " + p);
}

/// run process
function run_p(b, a) {
  cp.spawn(b, a, {
    stdio: "inherit",
  });
}

function get_a() {
  const a = process.argv.slice(2);
  //console.log(a);

  return a;
}

function run_bin_win32(name, a) {
  const p = get_p(name);
  const b = require(p);

  b.run_bin(a);
}

/// run bin
function run_bin(name, a) {
  if (null == a) {
    a = get_a();
  }

  if ("win32" == process.platform) {
    run_bin_win32(name, a);
  } else {
    const b = bin(name);

    run_p(b, a);
  }
}

module.exports = {
  bin,
  run_bin,
};
