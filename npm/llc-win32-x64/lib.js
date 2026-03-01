// llc-win32-x64/lib.js
const path = require("path");

const d = require("@pm-spl/llvm-dll-win32-x64");

/// run llc.exe
function run_bin(a) {
  const b = path.join(__dirname, "lib/llc.exe");
  d.run_p(b, a);
}

module.exports = {
  run_bin,
};
