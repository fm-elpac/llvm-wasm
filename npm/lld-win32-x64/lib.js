// lld-win32-x64/lib.js
const path = require("path");

const d = require("@pm-spl/llvm-dll-win32-x64");

/// run lld.exe
function run_bin(a) {
  const b = path.join(__dirname, "lib/lld.exe");
  d.run_p(b, a);
}

module.exports = {
  run_bin,
};
