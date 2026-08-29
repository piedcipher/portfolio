// Compiles a dart2wasm-generated main module from `source` which can then
// be instantiated via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string'], importedStringConstants: ''};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm module from `bytes` which is then
// instantiable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string'], importedStringConstants: ''};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredModules` is a JS function that takes an array of module names
  //   matching wasm files produced by the dart2wasm compiler. It also takes a
  //   callback that should be invoked for each loaded module with 2 arguments:
  //   (1) the module name, (2) the loaded module in a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`. The callback
  //   returns a Promise that resolves when the module is instantiated.
  //   loadDeferredModules should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  // `loadDeferredId` is a JS function that takes load ID produced by the
  //   compiler when the `use-load-ids` option is passed. Each load ID maps to
  //   one or more wasm files as specified in the emitted JSON file. It also
  //   takes a callback that should be invoked for each loaded module with 2
  //   arguments: (1) the module name, (2) the loaded module in a format
  //   supported by `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  //   The callback returns a Promise that resolves when the module is
  //   instantiated.
  //   loadDeferredId should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  async instantiate(additionalImports, {loadDeferredModules, loadDeferredId} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + value;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {
            AB: x0 => new Int16Array(x0),
      AC: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      AD: o => {
        if (o === null || o === undefined) return 0;
        if (typeof(o) === 'string') return 1;
        return 2;
      },
      AE: x0 => globalThis.parseFloat(x0),
      AF: x0 => x0.touches,
      AG: x0 => x0.v8BreakIterator,
      AH: x0 => x0.data,
      AI: () => globalThis.WeakRef,
      AJ: x0 => x0.send(),
      AK: (x0,x1) => x0.forEach(x1),
      AL: x0 => x0.code,
      B: s => printToConsole(s),
      BB: x0 => new Uint16Array(x0),
      BC: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      BD: x0 => x0.tabIndex,
      BE: (x0,x1) => x0.getComputedStyle(x1),
      BF: x0 => x0.pressure,
      BG: () => globalThis.Intl,
      BH: (x0,x1) => x0.removeAttribute(x1),
      BI: (x0,x1) => x0.getRandomValues(x1),
      BJ: x0 => x0.status,
      BK: x0 => x0.name,
      BL: x0 => x0.error,
      C: Function.prototype.call.bind(Number.prototype.toString),
      CB: x0 => new Int32Array(x0),
      CC: (x0,x1) => x0.querySelector(x1),
      CD: (x0,x1) => x0.contains(x1),
      CE: x0 => x0.documentElement,
      CF: x0 => x0.tiltY,
      CG: (x0,x1) => x0.segment(x1),
      CH: (x0,x1) => { x0.value = x1 },
      CI: () => globalThis.crypto,
      CJ: x0 => x0.response,
      CK: x0 => x0.statusText,
      CL: (x0,x1) => x0.start(x1),
      D: Function.prototype.call.bind(BigInt.prototype.toString),
      DB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      DC: (x0,x1) => x0.item(x1),
      DD: x0 => x0.activeElement,
      DE: x0 => x0.computedStyleMap(),
      DF: x0 => x0.tiltX,
      DG: x0 => x0.index,
      DH: (x0,x1) => { x0.value = x1 },
      DI: l => new DataView(new ArrayBuffer(l)),
      DJ: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      DK: x0 => x0.url,
      DL: (x0,x1) => x0.end(x1),
      E: (exn) => {
        let stackString = exn.toString();
        let frames = stackString.split('\n');
        let drop = 4;
        if (frames[0].startsWith('Error')) {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      EB: x0 => new Uint32Array(x0),
      EC: x0 => x0.length,
      ED: x0 => x0.parentNode,
      EE: (x0,x1) => x0.get(x1),
      EF: x0 => x0.pointerType,
      EG: x0 => x0.next(),
      EH: x0 => x0.value,
      EI: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      EJ: (x0,x1) => { x0.responseType = x1 },
      EK: x0 => x0.status,
      EL: x0 => x0.length,
      F: () => new Error().stack,
      FB: x0 => new Float32Array(x0),
      FC: (x0,x1) => x0.querySelectorAll(x1),
      FD: x0 => x0.tagName,
      FE: (o, p) => p in o,
      FF: x0 => x0.pointerId,
      FG: x0 => x0.value,
      FH: x0 => x0.selectionDirection,
      FI: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
      FJ: () => new XMLHttpRequest(),
      FK: x0 => x0.getReader(),
      FL: x0 => x0.buffered,
      G: s => JSON.stringify(s),
      GB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      GC: (x0,x1) => x0.getAttribute(x1),
      GD: x0 => x0.target,
      GE: (x0,x1) => { x0.textContent = x1 },
      GF: x0 => x0.getCoalescedEvents(),
      GG: x0 => x0.done,
      GH: x0 => x0.selectionStart,
      GI: x0 => x0.naturalHeight,
      GJ: (x0,x1) => x0.append(x1),
      GK: x0 => x0.read(),
      GL: x0 => x0.videoWidth,
      H: Function.prototype.call.bind(Number.prototype.toString),
      HB: x0 => new Float64Array(x0),
      HC: x0 => x0.remove(),
      HD: x0 => x0.clientY,
      HE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      HF: (x0,x1) => x0.getModifierState(x1),
      HG: (o, m, a) => o[m].apply(o, a),
      HH: x0 => x0.selectionEnd,
      HI: x0 => x0.naturalWidth,
      HJ: (x0,x1,x2) => x0.insertRule(x1,x2),
      HK: x0 => x0.value,
      HL: x0 => x0.videoHeight,
      I: Function.prototype.call.bind(String.prototype.indexOf),
      IB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      IC: (x0,x1) => x0.appendChild(x1),
      ID: x0 => x0.clientX,
      IE: x0 => x0.matches,
      IF: s => s.trimLeft(),
      IG: x0 => x0.iterator,
      IH: x0 => x0.value,
      II: (x0,x1) => x0.createElement(x1),
      IJ: (x0,x1) => x0.add(x1),
      IK: x0 => x0.done,
      IL: x0 => x0.duration,
      J: (s, p, i) => s.lastIndexOf(p, i),
      JB: x0 => new ArrayBuffer(x0),
      JC: (x0,x1) => x0.append(x1),
      JD: (x0,x1,x2) => x0.setAttribute(x1,x2),
      JE: (x0,x1) => x0.matchMedia(x1),
      JF: (x0,x1) => x0[x1],
      JG: () => globalThis.Symbol,
      JH: x0 => x0.selectionDirection,
      JI: (x0,x1) => { x0.pointerEvents = x1 },
      JJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      JK: x0 => x0.cancel(),
      JL: (x0,x1) => { x0.playsInline = x1 },
      K: (exn) => {
        if (exn instanceof Error) {
          return exn.stack;
        } else {
          return null;
        }
      },
      KB: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      KC: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      KD: x0 => x0.getBoundingClientRect(),
      KE: x0 => x0.matches,
      KF: x0 => x0.index,
      KG: (x0,x1) => new Intl.Segmenter(x0,x1),
      KH: x0 => x0.selectionStart,
      KI: (x0,x1) => { x0.height = x1 },
      KJ: x0 => x0.preventDefault(),
      KK: x0 => x0.body,
      KL: (x0,x1) => { x0.controls = x1 },
      L: o => o === undefined,
      LB: (x0,x1,x2) => new DataView(x0,x1,x2),
      LC: x0 => x0.style,
      LD: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      LE: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      LF: s => s.toUpperCase(),
      LG: x0 => x0.Segmenter,
      LH: x0 => x0.selectionEnd,
      LI: (x0,x1) => { x0.width = x1 },
      LJ: x0 => x0.createRange(),
      LK: x0 => x0.headers,
      LL: (x0,x1) => { x0.autoplay = x1 },
      M: o => String(o),
      MB: (o, p) => o[p],
      MC: x0 => x0.debugShowSemanticsNodes,
      MD: s => new Date(s * 1000).getTimezoneOffset() * 60,
      ME: f => f.dartFunction,
      MF: x0 => x0.flags,
      MG: x0 => x0.buffer,
      MH: (x0,x1) => { x0.name = x1 },
      MI: x0 => x0.style,
      MJ: (x0,x1) => x0.selectNode(x1),
      MK: x0 => x0.signal,
      ML: x0 => x0.currentTime,
      N: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      NB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      NC: o => o,
      ND: Date.now,
      NE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      NF: (a, s) => a.join(s),
      NG: x0 => x0.wasmMemory,
      NH: (x0,x1) => { x0.placeholder = x1 },
      NI: (x0,x1) => { x0.src = x1 },
      NJ: x0 => x0.getSelection(),
      NK: (x0,x1,x2) => x0.insertBefore(x1,x2),
      NL: (x0,x1) => { x0.playbackRate = x1 },
      O: (x0,x1) => x0.didCreateEngineInitializer(x1),
      OB: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      OC: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'boolean') return 1;
        return 2;
      },
      OD: (handle) => clearTimeout(handle),
      OE: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      OF: (x0,x1) => x0.error(x1),
      OG: () => globalThis.window._flutter_skwasmInstance,
      OH: (x0,x1) => { x0.autocomplete = x1 },
      OI: () => globalThis.document,
      OJ: x0 => x0.removeAllRanges(),
      OK: x0 => x0.id,
      OL: x0 => x0.pause(),
      P: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      PB: o => o.byteOffset,
      PC: (x0,x1) => x0.warn(x1),
      PD: (x0,x1) => x0.closest(x1),
      PE: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      PF: () => globalThis.console,
      PG: () => new TextDecoder(),
      PH: (x0,x1) => { x0.type = x1 },
      PI: x0 => x0.src,
      PJ: (x0,x1) => x0.addRange(x1),
      PK: x0 => x0.offsetHeight,
      PL: x0 => x0.play(),
      Q: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      QB: o => o.buffer,
      QC: x0 => x0.console,
      QD: x0 => x0.bottom,
      QE: (o, i) => o[i],
      QF: s => s.trimRight(),
      QG: (map, o, v) => map.set(o, v),
      QH: (x0,x1) => { x0.name = x1 },
      QI: x0 => x0.close(),
      QJ: () => globalThis.window,
      QK: x0 => x0.offsetWidth,
      QL: x0 => x0.message,
      R: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      RB: Function.prototype.call.bind(DataView.prototype.getUint8),
      RC: () => globalThis.window,
      RD: x0 => x0.top,
      RE: o => o.length,
      RF: x0 => x0.blur(),
      RG: (map, o) => map.get(o),
      RH: (x0,x1) => { x0.placeholder = x1 },
      RI: (o, p, v) => o[p] = v,
      RJ: (x0,x1) => { x0.innerText = x1 },
      RK: x0 => x0.stopPropagation(),
      RL: (x0,x1) => { x0.currentTime = x1 },
      S: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      SB: (b, o) => new DataView(b, o),
      SC: (o, c) => o instanceof c,
      SD: x0 => x0.right,
      SE: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        // Feature check for `SharedArrayBuffer` before doing a type-check.
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
            return 17;
        }
        if (o instanceof Promise) return 18;
        return 19;
      },
      SF: x0 => x0.button,
      SG: () => new WeakMap(),
      SH: (x0,x1) => { x0.scrollTop = x1 },
      SI: x0 => x0.height,
      SJ: x0 => x0.offsetY,
      SK: x0 => x0.disabled,
      SL: x0 => x0.userAgent,
      T: x0 => new Promise(x0),
      TB: (b, o, l) => new DataView(b, o, l),
      TC: (x0,x1) => x0.exec(x1),
      TD: x0 => x0.left,
      TE: x0 => x0.language,
      TF: x0 => x0.innerHeight,
      TG: (handle) => clearInterval(handle),
      TH: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      TI: x0 => x0.width,
      TJ: x0 => x0.offsetX,
      TK: (x0,x1) => { x0.min = x1 },
      TL: x0 => x0.navigator,
      U: (x0,x1,x2) => x0.call(x1,x2),
      UB: Function.prototype.call.bind(DataView.prototype.getFloat64),
      UC: x0 => x0.length,
      UD: x0 => x0.clientY,
      UE: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      UF: x0 => x0.innerWidth,
      UG: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      UH: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      UI: (x0,x1,x2,x3,x4,x5) => x0.createImageBitmap(x1,x2,x3,x4,x5),
      UJ: x0 => x0.button,
      UK: (x0,x1) => { x0.max = x1 },
      UL: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      V: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      VB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float64Array) return 1;
        return 2;
      },
      VC: (x0,x1) => { x0.lastIndex = x1 },
      VD: x0 => x0.clientX,
      VE: () => globalThis.window.FinalizationRegistry,
      VF: x0 => x0.height,
      VG: () => Date.now(),
      VH: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      VI: (x0,x1,x2) => x0.createImageBitmap(x1,x2),
      VJ: x0 => x0.classList,
      VK: (x0,x1) => { x0.disabled = x1 },
      VL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      W: x0 => new Array(x0),
      WB: Function.prototype.call.bind(DataView.prototype.setFloat64),
      WC: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      WD: x0 => x0.changedTouches,
      WE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      WF: x0 => x0.width,
      WG: x0 => x0.debugSkipFontRetryDelay,
      WH: x0 => x0.keyCode,
      WI: (x0,x1) => x0.createImageBitmap(x1),
      WJ: x0 => x0.sheet,
      WK: (x0,x1) => { x0.scrollLeft = x1 },
      WL: (x0,x1,x2) => x0.addEventListener(x1,x2),
      X: o => [o],
      XB: (t, s) => t.set(s),
      XC: o => o instanceof RegExp,
      XD: x0 => x0.offsetY,
      XE: x0 => new window.FinalizationRegistry(x0),
      XF: x0 => x0.clientHeight,
      XG: x0 => x0.status,
      XH: (x0,x1) => x0.scrollIntoView(x1),
      XI: x0 => new Blob(x0),
      XJ: x0 => x0.head,
      XK: (x0,x1) => { x0.spellcheck = x1 },
      XL: x0 => x0.preventDefault(),
      Y: (o0, o1) => [o0, o1],
      YB: Function.prototype.call.bind(DataView.prototype.setFloat32),
      YC: (string, times) => string.repeat(times),
      YD: x0 => x0.offsetX,
      YE: (x0,x1) => x0.unregister(x1),
      YF: x0 => x0.clientWidth,
      YG: (x0,x1,x2) => x0.set(x1,x2),
      YH: x0 => x0.multiViewEnabled,
      YI: x0 => x0.close(),
      YJ: x0 => x0.pop(),
      YK: (x0,x1) => { x0.disabled = x1 },
      YL: x0 => x0.firstElementChild,
      Z: (o0, o1, o2) => [o0, o1, o2],
      ZB: Function.prototype.call.bind(DataView.prototype.getFloat32),
      ZC: x0 => x0.dotAll,
      ZD: x0 => x0.type,
      ZE: (x0,x1) => x0.contains(x1),
      ZF: (x0,x1) => { x0.content = x1 },
      ZG: x0 => x0.arrayBuffer(),
      ZH: (x0,x1) => x0.replaceWith(x1),
      ZI: x0 => x0.naturalHeight,
      ZJ: x0 => x0.input,
      ZK: (x0,x1) => x0.transferFromImageBitmap(x1),
      ZL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      a: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      aB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float32Array) return 1;
        return 2;
      },
      aC: x0 => x0.unicode,
      aD: x0 => x0.maxTouchPoints,
      aE: (s) => +s,
      aF: (x0,x1) => { x0.name = x1 },
      aG: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof ArrayBuffer) return 1;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 2;
        }
        return 3;
      },
      aH: (x0,x1) => { x0.className = x1 },
      aI: x0 => x0.naturalWidth,
      aJ: (o, p) => p in o,
      aK: (x0,x1) => x0.getContext(x1),
      aL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      b: (x0,x1,x2) => { x0[x1] = x2 },
      bB: Function.prototype.call.bind(DataView.prototype.getUint32),
      bC: x0 => x0.ignoreCase,
      bD: x0 => x0.platform,
      bE: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      bF: x0 => x0.head,
      bG: (x0,x1) => x0.fetch(x1),
      bH: (x0,x1) => { x0.tabIndex = x1 },
      bI: (x0,x1) => { x0.src = x1 },
      bJ: x0 => x0.groups,
      bK: (x0,x1) => { x0.height = x1 },
      bL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      c: o => o,
      cB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint32Array) return 1;
        return 2;
      },
      cC: x0 => x0.multiline,
      cD: x0 => x0.body,
      cE: s => s.trim(),
      cF: (x0,x1) => x0.removeChild(x1),
      cG: x0 => x0.fontFallbackBaseUrl,
      cH: (x0,x1) => { x0.action = x1 },
      cI: x0 => x0.displayHeight,
      cJ: () => globalThis.window.navigator.userAgent,
      cK: (x0,x1) => { x0.width = x1 },
      cL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      d: (o, p) => o[p],
      dB: Function.prototype.call.bind(DataView.prototype.getInt32),
      dC: (string, token) => string.split(token),
      dD: () => globalThis.document,
      dE: x0 => x0.classList,
      dF: x0 => x0.firstChild,
      dG: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      dH: (x0,x1) => { x0.method = x1 },
      dI: x0 => x0.displayWidth,
      dJ: (x0,x1,x2) => x0.postMessage(x1,x2),
      dK: x0 => x0.rasterEndMilliseconds,
      dL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      e: () => globalThis,
      eB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int32Array) return 1;
        return 2;
      },
      eC: o => o instanceof Array,
      eD: (x0,x1,x2) => x0.addEventListener(x1,x2),
      eE: x0 => x0.preventDefault(),
      eF: x0 => x0.viewConstraints,
      eG: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      eH: (x0,x1) => { x0.noValidate = x1 },
      eI: x0 => x0.duration,
      eJ: x0 => x0.contentWindow,
      eK: x0 => x0.rasterStartMilliseconds,
      eL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      f: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fB: o => o instanceof Uint16Array,
      fC: (a, i) => a[i],
      fD: x0 => x0.hasFocus(),
      fE: x0 => x0.parent,
      fF: x0 => x0.hostElement,
      fG: (d, digits) => d.toFixed(digits),
      fH: x0 => x0.isConnected,
      fI: (x0,x1) => ({frameIndex: x0,completeFramesOnly: x1}),
      fJ: (x0,x1) => { x0.allow = x1 },
      fK: x0 => x0.imageBitmaps,
      fL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      g: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gB: Function.prototype.call.bind(DataView.prototype.getUint16),
      gC: a => a.length,
      gD: x0 => x0.relatedTarget,
      gE: x0 => x0.timeStamp,
      gF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gG: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      gH: x0 => x0.click(),
      gI: (x0,x1) => x0.decode(x1),
      gJ: (x0,x1) => { x0.border = x1 },
      gK: x0 => x0.canvasKitMaximumSurfaces,
      gL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      h: (x0,x1) => ({addView: x0,removeView: x1}),
      hB: o => o instanceof Int16Array,
      hC: (x0,x1) => x0.test(x1),
      hD: x0 => x0.shiftKey,
      hE: (x0,x1) => x0.hasAttribute(x1),
      hF: x0 => ({runApp: x0}),
      hG: x0 => x0.history,
      hH: (x0,x1) => x0.getElementsByClassName(x1),
      hI: x0 => x0.image,
      hJ: (x0,x1) => { x0.height = x1 },
      hK: x0 => x0.nextSibling,
      hL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      i: (l, r) => l === r,
      iB: Function.prototype.call.bind(DataView.prototype.getInt16),
      iC: x0 => x0.userAgent,
      iD: (decoder, codeUnits) => decoder.decode(codeUnits),
      iE: x0 => x0.buttons,
      iF: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      iG: x0 => x0.search,
      iH: (x0,x1) => x0.dispatchEvent(x1),
      iI: x0 => x0.close(),
      iJ: (x0,x1) => { x0.width = x1 },
      iK: (x0,x1) => x0.debug(x1),
      iL: (x0,x1) => { x0.preload = x1 },
      j: x0 => x0.random(),
      jB: o => o instanceof Uint8ClampedArray,
      jC: x0 => x0.navigator,
      jD: () => new TextDecoder("utf-8", {fatal: true}),
      jE: x0 => x0.ctrlKey,
      jF: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      jG: x0 => x0.location,
      jH: (x0,x1) => x0.createEvent(x1),
      jI: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      jJ: x0 => x0.style,
      jK: x0 => x0.hostElement,
      jL: x0 => x0.src,
      k: o => o,
      kB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint8Array) return 1;
        return 2;
      },
      kC: Function.prototype.call.bind(String.prototype.toLowerCase),
      kD: () => new TextDecoder("utf-8", {fatal: false}),
      kE: x0 => x0.y,
      kF: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      kG: x0 => x0.pathname,
      kH: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      kI: x0 => new window.ImageDecoder(x0),
      kJ: (x0,x1) => { x0.id = x1 },
      kK: x0 => x0.location,
      kL: (x0,x1) => x0.setSinkId(x1),
      l: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'number') return 1;
        return 2;
      },
      lB: Function.prototype.call.bind(DataView.prototype.setInt32),
      lC: Object.is,
      lD: (a, i, v) => a[i] = v,
      lE: x0 => x0.x,
      lF: () => typeof dartUseDateNowForTicks !== "undefined",
      lG: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      lH: x0 => x0.readText(),
      lI: x0 => x0.name,
      lJ: (x0,x1) => x0.createElement(x1),
      lK: (x0,x1) => x0.getModifierState(x1),
      lL: x0 => x0.length,
      m: () => globalThis.Math,
      mB: Function.prototype.call.bind(DataView.prototype.setUint32),
      mC: x0 => x0.vendor,
      mD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      mE: x0 => x0.scrollTop,
      mF: () => Date.now(),
      mG: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      mH: x0 => x0.clipboard,
      mI: x0 => x0.repetitionCount,
      mJ: () => globalThis.document,
      mK: x0 => x0.metaKey,
      mL: x0 => x0.getReader(),
      n: (x0,x1) => x0.prepend(x1),
      nB: Function.prototype.call.bind(DataView.prototype.setInt16),
      nC: (x0,x1) => x0.createTextNode(x1),
      nD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      nE: x0 => x0.offsetTop,
      nF: () => 1000 * performance.now(),
      nG: o => Object.keys(o),
      nH: (x0,x1) => x0.writeText(x1),
      nI: x0 => x0.frameCount,
      nJ: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      nK: x0 => x0.altKey,
      nL: x0 => x0.value,
      o: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      oB: Function.prototype.call.bind(DataView.prototype.setUint16),
      oC: (x0,x1) => { x0.id = x1 },
      oD: x0 => x0.visibilityState,
      oE: x0 => x0.scrollLeft,
      oF: (x0,x1) => x0.requestAnimationFrame(x1),
      oG: x0 => x0.state,
      oH: x0 => x0.unlock(),
      oI: x0 => x0.selectedTrack,
      oJ: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      oK: x0 => x0.ctrlKey,
      oL: x0 => x0.done,
      p: b => !!b,
      pB: Function.prototype.call.bind(DataView.prototype.setUint8),
      pC: (x0,x1) => { x0.nonce = x1 },
      pD: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      pE: x0 => x0.offsetLeft,
      pF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      pG: x0 => x0.hash,
      pH: (x0,x1) => x0.lock(x1),
      pI: x0 => x0.completed,
      pJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      pK: x0 => x0.isComposing,
      pL: x0 => x0.read(),
      q: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qB: Function.prototype.call.bind(DataView.prototype.setInt8),
      qC: x0 => x0.nonce,
      qD: x0 => x0.disconnect(),
      qE: x0 => x0.offsetParent,
      qF: x0 => x0.now(),
      qG: x0 => x0.state,
      qH: x0 => x0.orientation,
      qI: x0 => x0.ready,
      qJ: x0 => x0.data,
      qK: x0 => x0.code,
      qL: x0 => x0.body,
      r: (x0,x1) => x0.focus(x1),
      rB: Function.prototype.call.bind(DataView.prototype.getInt8),
      rC: () => globalThis.window.flutterConfiguration,
      rD: x0 => new Intl.Locale(x0),
      rE: (o, p, r) => o.replace(p, () => r),
      rF: x0 => x0.performance,
      rG: (x0,x1) => x0.go(x1),
      rH: (x0,x1) => x0.querySelector(x1),
      rI: x0 => x0.tracks,
      rJ: () => globalThis.window,
      rK: x0 => x0.repeat,
      rL: (x0,x1) => new OffscreenCanvas(x0,x1),
      s: () => ({}),
      sB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int8Array) return 1;
        return 2;
      },
      sC: (x0,x1) => x0.attachShadow(x1),
      sD: x0 => x0.region,
      sE: (o, p, r) => o.replaceAll(p, () => r),
      sF: x0 => new Uint8Array(x0),
      sG: x0 => x0.parentElement,
      sH: (x0,x1) => { x0.title = x1 },
      sI: () => globalThis.window.ImageDecoder,
      sJ: x0 => x0.id,
      sK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      sL: x0 => x0.assetBase,
      t: (o, p, v) => o[p] = v,
      tB: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      tC: (x0,x1) => x0.createElement(x1),
      tD: x0 => x0.script,
      tE: x0 => x0.deltaMode,
      tF: (x0,x1,x2) => x0.slice(x1,x2),
      tG: (x0,x1) => x0.querySelectorAll(x1),
      tH: (x0,x1) => x0.vibrate(x1),
      tI: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      tJ: (x0,x1) => { x0.src = x1 },
      tK: (x0,x1) => x0.removeAttribute(x1),
      tL: x0 => x0.loader,
      u: () => [],
      uB: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      uC: x0 => x0.scale,
      uD: x0 => x0.language,
      uE: x0 => x0.deltaY,
      uF: (x0,x1) => x0.decode(x1),
      uG: x0 => x0.maxHeight,
      uH: x0 => x0.content,
      uI: (a, s, e) => a.slice(s, e),
      uJ: (x0,x1) => { x0.srcdoc = x1 },
      uK: x0 => x0.load(),
      uL: () => globalThis._flutter,
      v: (a, i) => a.push(i),
      vB: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      vC: x0 => x0.visualViewport,
      vD: x0 => x0.languages,
      vE: x0 => x0.deltaX,
      vF: (x0,x1) => x0.adoptText(x1),
      vG: x0 => x0.maxWidth,
      vH: x0 => x0.document,
      vI: x0 => x0.decode(),
      vJ: () => new AbortController(),
      vK: (x0,x1) => { x0.loop = x1 },
      w: x0 => new Int8Array(x0),
      wB: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      wC: x0 => x0.devicePixelRatio,
      wD: (x0,x1) => x0.observe(x1),
      wE: x0 => x0.wheelDeltaY,
      wF: x0 => x0.first(),
      wG: x0 => x0.minHeight,
      wH: (a, i) => a.splice(i, 1),
      wI: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      wJ: (x0,x1,x2,x3,x4,x5) => ({method: x0,headers: x1,body: x2,credentials: x3,redirect: x4,signal: x5}),
      wK: (x0,x1) => { x0.volume = x1 },
      x: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      xB: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      xC: x0 => x0.height,
      xD: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      xE: x0 => x0.wheelDeltaX,
      xF: x0 => x0.next(),
      xG: x0 => x0.minWidth,
      xH: a => a.pop(),
      xI: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      xJ: (x0,x1) => globalThis.fetch(x0,x1),
      xK: (x0,x1) => { x0.muted = x1 },
      y: x0 => new Uint8Array(x0),
      yB: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      yC: x0 => x0.width,
      yD: x0 => new ResizeObserver(x0),
      yE: x0 => x0.key,
      yF: x0 => x0.current(),
      yG: (x0,x1) => x0.removeProperty(x1),
      yH: x0 => new WeakRef(x0),
      yI: (x0,x1,x2) => x0.addEventListener(x1,x2),
      yJ: (x0,x1) => x0.get(x1),
      yK: (x0,x1) => { x0.src = x1 },
      z: x0 => new Uint8ClampedArray(x0),
      zB: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      zC: x0 => x0.screen,
      zD: (x0,x1) => x0.getPropertyValue(x1),
      zE: x0 => x0.identifier,
      zF: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      zG: (x0,x1) => x0.add(x1),
      zH: x0 => x0.deref(),
      zI: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      zJ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2) { return wasmFunction(f,arguments.length,x0,x1,x2) }),
      zK: x0 => x0.message,

    };

    const baseImports = {
      _: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      WebAssembly: {
        JSTag: WebAssembly.JSTag,
      },
      "": new Proxy({}, { get(_, prop) { return prop; } }),

    };

    const jsStringPolyfill = {
      "charCodeAt": (s, i) => s.charCodeAt(i),
      "compare": (s1, s2) => {
        if (s1 < s2) return -1;
        if (s1 > s2) return 1;
        return 0;
      },
      "concat": (s1, s2) => s1 + s2,
      "equals": (s1, s2) => s1 === s2,
      "fromCharCode": (i) => String.fromCharCode(i),
      "length": (s) => s.length,
      "substring": (s, a, b) => s.substring(a, b),
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
      "intoCharCodeArray": (s, a, start) => {
        if (s === '') return 0;

        const write = dartInstance.exports.$wasmI16ArraySet;
        for (var i = 0; i < s.length; ++i) {
          write(a, start++, s.charCodeAt(i));
        }
        return s.length;
      },
      "test": (s) => typeof s == "string",
    };


    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}
