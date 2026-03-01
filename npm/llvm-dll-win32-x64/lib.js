// llvm-dll-win32-x64/lib.js
const path = require("path");
const cp = require("child_process");

/// run process
function run_p(b, a) {
  // fix DLL PATH
  const d = path.join(__dirname, "lib");
  process.env["PATH"] += ";" + d;

  //console.log("PATH", process.env["PATH"]);
  cp.spawn(b, a, {
    stdio: "inherit",
  });
}

module.exports = {
  run_p,
};
