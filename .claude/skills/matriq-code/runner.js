// MATRIQ code runner — copy this whole file VERBATIM into the page's inline <script>.
// Runs learner JavaScript in a throwaway Web Worker (blob URL), so an infinite loop or a
// crash never freezes the page. No eval/new Function: the code is part of the worker script.
//
// API:
//   const r = await runCode(userCode, tests, timeoutMs?)
//     tests: [{ expr: "sum([1, 2, 3])", expected: 6 }, ...]   (expr is a JS expression)
//   r = {
//     logs:    ["...", ...],              // console.log / warn / error output, in order
//     results: [{ ok, got }, ...],        // one per test, same order as `tests`
//     error:   "SyntaxError: ..." | null, // compile or top-level runtime error
//     line:    12 | null,                 // line in the learner's code, when known
//     timeout: true | false,              // killed after timeoutMs (likely an infinite loop)
//   }
// Equality is deep, via JSON.stringify (so object key order matters).
// Only synchronous code is tested; async results are not awaited.

const RUNNER_PRELUDE = [
  "const __logs = [];",
  "const __fmt = (v) => { if (typeof v === 'string') return v; if (v === undefined) return 'undefined'; if (typeof v === 'function') return '[Function]'; try { return JSON.stringify(v); } catch (e) { return String(v); } };",
  "console.log = console.info = console.warn = console.error = (...a) => { if (__logs.length < 200) __logs.push(a.map(__fmt).join(' ')); };",
  "const __eq = (a, b) => { try { return JSON.stringify(a) === JSON.stringify(b); } catch (e) { return false; } };",
  "const __results = [];",
  "self.onerror = (msg, src, line) => { postMessage({ logs: __logs, results: __results, error: String(msg).replace(/^Uncaught /, ''), line: line ? line - __PRELUDE_LINES__ : null }); return true; };",
].join("\n");
const RUNNER_PRELUDE_LINES = RUNNER_PRELUDE.split("\n").length;

function runnerBuildTests(tests) {
  return tests.map((t) =>
    "try { const __v = (" + t.expr + "); __results.push({ ok: __eq(__v, " + JSON.stringify(t.expected) + "), got: __fmt(__v) }); }\n" +
    "catch (e) { __results.push({ ok: false, got: (e && e.name ? e.name + ': ' + e.message : String(e)) }); }"
  ).join("\n");
}

function runCode(userCode, tests, timeoutMs) {
  timeoutMs = timeoutMs || 3000;
  return new Promise((resolve) => {
    const prelude = RUNNER_PRELUDE.replace("__PRELUDE_LINES__", String(RUNNER_PRELUDE_LINES));
    const src = prelude + "\n" + userCode + "\n;\n" + runnerBuildTests(tests || []) +
      "\npostMessage({ logs: __logs, results: __results, error: null, line: null });";
    let url, worker;
    try {
      url = URL.createObjectURL(new Blob([src], { type: "text/javascript" }));
      worker = new Worker(url);
    } catch (e) {
      resolve({ logs: [], results: [], error: "Runner is not available in this browser.", line: null, timeout: false });
      return;
    }
    let finished = false;
    const done = (r) => {
      if (finished) return;
      finished = true;
      clearTimeout(timer);
      worker.terminate();
      URL.revokeObjectURL(url);
      resolve(Object.assign({ logs: [], results: [], error: null, line: null, timeout: false }, r));
    };
    const timer = setTimeout(() => done({ timeout: true }), timeoutMs);
    worker.onmessage = (e) => done(e.data);
    // Compile errors (e.g. SyntaxError) never reach the in-worker handler; they land here.
    worker.onerror = (e) => {
      e.preventDefault();
      done({ error: String(e.message || "Error").replace(/^Uncaught /, ""),
             line: e.lineno ? e.lineno - RUNNER_PRELUDE_LINES : null });
    };
  });
}
