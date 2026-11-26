// Compiles a dart2wasm-generated main module from `source` which can then
// be instantiated via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string'], importedStringConstants: ''};
  return new CompiledApp(
      await _compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm module from `bytes` which is then
// instantiable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string'], importedStringConstants: ''};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

let _isCompileStreamingSupported;
async function _compileStreaming(source, builtins) {
  _isCompileStreamingSupported ??= WebAssembly.compileStreaming(
    new Response(
      new Uint8Array([0,97,115,109,1,0,0,0,1,4,1,96,0,0,2,23,1,14,119,97,115,109,58,106,115,45,115,116,114,105,110,103,4,99,97,115,116,0,0]),
      {headers: {'Content-Type': 'application/wasm'}},
    ),
    builtins,
  ).then(() => false, (e) => e instanceof WebAssembly.CompileError);
  if (await _isCompileStreamingSupported) {
    return WebAssembly.compileStreaming(source, builtins);
  }
  return WebAssembly.compile(await (await source).arrayBuffer(), builtins);
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
  //   returns a Promise that resolves to `{module, instance}` (the compiled
  //   `WebAssembly.Module` and instantiated `WebAssembly.Instance`) when the
  //   module is instantiated.
  //   loadDeferredModules should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  // `loadDeferredId` is a JS function that takes load ID produced by the
  //   compiler when the `use-load-ids` option is passed. Each load ID maps to
  //   one or more wasm files as specified in the emitted JSON file. It also
  //   takes a callback that should be invoked for each loaded module with 2
  //   arguments: (1) the module name, (2) the loaded module in a format
  //   supported by `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  //   The callback returns a Promise that resolves to `{module, instance}`
  //   (the compiled `WebAssembly.Module` and instantiated
  //   `WebAssembly.Instance`) when the module is instantiated.
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
      AD: x0 => x0.screen,
      AE: x0 => x0.matches,
      AF: x0 => x0.tiltY,
      AG: x0 => x0.v8BreakIterator,
      AH: (x0,x1) => { x0.tabIndex = x1 },
      AI: l => new DataView(new ArrayBuffer(l)),
      AJ: x0 => x0.response,
      AK: (x0,x1) => { x0.min = x1 },
      AL: (x0,x1) => { x0.currentTime = x1 },
      B: s => printToConsole(s),
      BB: x0 => new Uint16Array(x0),
      BC: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      BD: o => {
        if (o === null || o === undefined) return 0;
        if (typeof(o) === 'string') return 1;
        return 2;
      },
      BE: (x0,x1) => x0.matchMedia(x1),
      BF: x0 => x0.tiltX,
      BG: () => globalThis.Intl,
      BH: (x0,x1) => { x0.value = x1 },
      BI: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      BJ: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      BK: (x0,x1) => { x0.max = x1 },
      BL: x0 => x0.userAgent,
      C: Function.prototype.call.bind(Number.prototype.toString),
      CB: x0 => new Int32Array(x0),
      CC: (x0,x1) => x0.querySelector(x1),
      CD: x0 => x0.tabIndex,
      CE: x0 => x0.matches,
      CF: x0 => x0.pointerType,
      CG: (x0,x1) => x0.segment(x1),
      CH: (x0,x1) => { x0.value = x1 },
      CI: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
      CJ: (x0,x1) => { x0.responseType = x1 },
      CK: (x0,x1) => { x0.disabled = x1 },
      CL: x0 => x0.navigator,
      D: Function.prototype.call.bind(BigInt.prototype.toString),
      DB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      DC: (x0,x1) => x0.item(x1),
      DD: (x0,x1) => x0.contains(x1),
      DE: f => f.dartFunction,
      DF: x0 => x0.pointerId,
      DG: x0 => x0.index,
      DH: x0 => x0.value,
      DI: x0 => x0.naturalHeight,
      DJ: () => new XMLHttpRequest(),
      DK: (x0,x1) => { x0.scrollLeft = x1 },
      DL: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
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
      ED: x0 => x0.activeElement,
      EE: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      EF: x0 => x0.getCoalescedEvents(),
      EG: x0 => x0.next(),
      EH: x0 => x0.selectionDirection,
      EI: x0 => x0.naturalWidth,
      EJ: (x0,x1) => x0.append(x1),
      EK: (x0,x1) => { x0.spellcheck = x1 },
      EL: (x0,x1,x2) => x0.addEventListener(x1,x2),
      F: o => String(o),
      FB: x0 => new Float32Array(x0),
      FC: (x0,x1) => x0.querySelectorAll(x1),
      FD: x0 => x0.parentNode,
      FE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      FF: s => s.trimLeft(),
      FG: x0 => x0.value,
      FH: x0 => x0.selectionStart,
      FI: (x0,x1) => x0.createElement(x1),
      FJ: (x0,x1,x2) => x0.insertRule(x1,x2),
      FK: (x0,x1) => { x0.disabled = x1 },
      FL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      G: () => new Error().stack,
      GB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      GC: (x0,x1) => x0.getAttribute(x1),
      GD: x0 => x0.tagName,
      GE: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      GF: s => s.toUpperCase(),
      GG: x0 => x0.done,
      GH: x0 => x0.selectionEnd,
      GI: (x0,x1) => { x0.pointerEvents = x1 },
      GJ: (x0,x1) => x0.add(x1),
      GK: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9) => x0.drawImage(x1,x2,x3,x4,x5,x6,x7,x8,x9),
      GL: x0 => x0.preventDefault(),
      H: s => JSON.stringify(s),
      HB: x0 => new Float64Array(x0),
      HC: x0 => x0.remove(),
      HD: x0 => x0.target,
      HE: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      HF: (x0,x1) => x0.test(x1),
      HG: (o, m, a) => o[m].apply(o, a),
      HH: x0 => x0.value,
      HI: (x0,x1) => { x0.height = x1 },
      HJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      HK: (x0,x1) => x0.getContext(x1),
      HL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      I: Function.prototype.call.bind(Number.prototype.toString),
      IB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      IC: (x0,x1) => x0.appendChild(x1),
      ID: x0 => x0.clientY,
      IE: (o, i) => o[i],
      IF: x0 => x0.flags,
      IG: x0 => x0.iterator,
      IH: x0 => x0.selectionDirection,
      II: (x0,x1) => { x0.width = x1 },
      IJ: x0 => x0.preventDefault(),
      IK: (x0,x1) => { x0.height = x1 },
      IL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      J: Function.prototype.call.bind(String.prototype.indexOf),
      JB: x0 => new ArrayBuffer(x0),
      JC: (x0,x1) => x0.append(x1),
      JD: x0 => x0.clientX,
      JE: o => o.length,
      JF: (a, s) => a.join(s),
      JG: () => globalThis.Symbol,
      JH: x0 => x0.selectionStart,
      JI: x0 => x0.style,
      JJ: x0 => x0.createRange(),
      JK: (x0,x1) => { x0.width = x1 },
      JL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      K: (s, p, i) => s.lastIndexOf(p, i),
      KB: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      KC: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      KD: (x0,x1,x2) => x0.addEventListener(x1,x2),
      KE: o => {
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
      KF: (x0,x1) => x0.error(x1),
      KG: (x0,x1) => new Intl.Segmenter(x0,x1),
      KH: x0 => x0.selectionEnd,
      KI: () => globalThis.document,
      KJ: (x0,x1) => x0.selectNode(x1),
      KK: (x0,x1) => x0.transferFromImageBitmap(x1),
      KL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      L: (exn) => {
        if (exn instanceof Error) {
          return exn.stack;
        } else {
          return null;
        }
      },
      LB: (x0,x1,x2) => new DataView(x0,x1,x2),
      LC: x0 => x0.style,
      LD: (x0,x1,x2) => x0.setAttribute(x1,x2),
      LE: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      LF: () => globalThis.console,
      LG: x0 => x0.Segmenter,
      LH: (x0,x1) => { x0.name = x1 },
      LI: (x0,x1) => { x0.src = x1 },
      LJ: x0 => x0.getSelection(),
      LK: x0 => x0.rasterEndMilliseconds,
      LL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      M: o => o === undefined,
      MB: (o, p) => o[p],
      MC: x0 => x0.debugShowSemanticsNodes,
      MD: (x0,x1) => x0.closest(x1),
      ME: () => globalThis.window.FinalizationRegistry,
      MF: s => s.trimRight(),
      MG: x0 => x0.buffer,
      MH: (x0,x1) => { x0.placeholder = x1 },
      MI: x0 => x0.firstElementChild,
      MJ: x0 => x0.removeAllRanges(),
      MK: x0 => x0.rasterStartMilliseconds,
      ML: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      N: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      NB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      NC: o => o,
      ND: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      NE: x0 => new window.FinalizationRegistry(x0),
      NF: x0 => x0.blur(),
      NG: x0 => x0.wasmMemory,
      NH: (x0,x1) => { x0.autocomplete = x1 },
      NI: x0 => x0.src,
      NJ: (x0,x1) => x0.addRange(x1),
      NK: x0 => x0.imageBitmaps,
      NL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      O: (x0,x1) => x0.didCreateEngineInitializer(x1),
      OB: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      OC: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'boolean') return 1;
        return 2;
      },
      OD: (handle) => clearTimeout(handle),
      OE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      OF: (x0,x1) => x0.setPointerCapture(x1),
      OG: () => globalThis.window._flutter_skwasmInstance,
      OH: (x0,x1) => { x0.type = x1 },
      OI: x0 => x0.close(),
      OJ: () => globalThis.window,
      OK: x0 => x0.canvasKitMaximumSurfaces,
      OL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      P: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      PB: o => o.byteOffset,
      PC: (x0,x1) => x0.warn(x1),
      PD: x0 => x0.maxTouchPoints,
      PE: (x0,x1) => x0.unregister(x1),
      PF: x0 => x0.button,
      PG: () => new TextDecoder(),
      PH: (x0,x1) => { x0.name = x1 },
      PI: (o, p, v) => o[p] = v,
      PJ: (x0,x1) => { x0.innerText = x1 },
      PK: x0 => x0.nextSibling,
      PL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      Q: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      QB: o => o.buffer,
      QC: x0 => x0.console,
      QD: x0 => x0.platform,
      QE: x0 => x0.preventDefault(),
      QF: (x0,x1) => x0.prepend(x1),
      QG: (map, o, v) => map.set(o, v),
      QH: (x0,x1) => { x0.placeholder = x1 },
      QI: x0 => x0.height,
      QJ: x0 => x0.offsetY,
      QK: (x0,x1) => x0.debug(x1),
      QL: (x0,x1) => { x0.preload = x1 },
      R: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      RB: Function.prototype.call.bind(DataView.prototype.getUint8),
      RC: () => globalThis.window,
      RD: s => new Date(s * 1000).getTimezoneOffset() * 60,
      RE: x0 => x0.parent,
      RF: x0 => x0.parentElement,
      RG: (map, o) => map.get(o),
      RH: (x0,x1) => { x0.scrollTop = x1 },
      RI: x0 => x0.width,
      RJ: x0 => x0.offsetX,
      RK: x0 => x0.hostElement,
      RL: x0 => x0.src,
      S: x0 => new Promise(x0),
      SB: (b, o) => new DataView(b, o),
      SC: (o, c) => o instanceof c,
      SD: Date.now,
      SE: x0 => x0.timeStamp,
      SF: x0 => x0.innerHeight,
      SG: () => new WeakMap(),
      SH: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      SI: (x0,x1,x2,x3,x4,x5) => x0.createImageBitmap(x1,x2,x3,x4,x5),
      SJ: x0 => x0.button,
      SK: x0 => x0.location,
      SL: (x0,x1) => x0.setSinkId(x1),
      T: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      TB: (b, o, l) => new DataView(b, o, l),
      TC: (x0,x1) => x0.exec(x1),
      TD: (x0,x1) => x0.contains(x1),
      TE: (x0,x1) => x0.hasAttribute(x1),
      TF: x0 => x0.innerWidth,
      TG: (d, digits) => d.toFixed(digits),
      TH: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      TI: (x0,x1,x2) => x0.createImageBitmap(x1,x2),
      TJ: x0 => x0.classList,
      TK: (x0,x1) => x0.getModifierState(x1),
      TL: x0 => x0.extraAssets,
      U: (x0,x1,x2) => x0.call(x1,x2),
      UB: Function.prototype.call.bind(DataView.prototype.getFloat64),
      UC: x0 => x0.length,
      UD: (decoder, codeUnits) => decoder.decode(codeUnits),
      UE: x0 => x0.type,
      UF: x0 => x0.height,
      UG: x0 => x0.maxHeight,
      UH: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      UI: (x0,x1) => x0.createImageBitmap(x1),
      UJ: x0 => x0.sheet,
      UK: x0 => x0.metaKey,
      UL: x0 => x0.fontManifest,
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
      VD: () => new TextDecoder("utf-8", {fatal: true}),
      VE: (x0,x1) => x0.getModifierState(x1),
      VF: x0 => x0.width,
      VG: x0 => x0.maxWidth,
      VH: x0 => x0.keyCode,
      VI: x0 => new Blob(x0),
      VJ: x0 => x0.head,
      VK: x0 => x0.altKey,
      VL: x0 => x0.assetManifest,
      W: x0 => new Array(x0),
      WB: Function.prototype.call.bind(DataView.prototype.setFloat64),
      WC: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      WD: () => new TextDecoder("utf-8", {fatal: false}),
      WE: x0 => x0.buttons,
      WF: x0 => x0.clientHeight,
      WG: x0 => x0.minHeight,
      WH: (x0,x1) => x0.scrollIntoView(x1),
      WI: x0 => x0.close(),
      WJ: x0 => x0.pop(),
      WK: x0 => x0.ctrlKey,
      WL: x0 => x0.buildConfig,
      X: o => [o],
      XB: (t, s) => t.set(s),
      XC: (string, times) => string.repeat(times),
      XD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      XE: x0 => x0.ctrlKey,
      XF: x0 => x0.clientWidth,
      XG: x0 => x0.minWidth,
      XH: x0 => x0.multiViewEnabled,
      XI: x0 => x0.naturalHeight,
      XJ: x0 => x0.input,
      XK: x0 => x0.isComposing,
      XL: x0 => x0.getReader(),
      Y: (o0, o1) => [o0, o1],
      YB: Function.prototype.call.bind(DataView.prototype.setFloat32),
      YC: o => o instanceof RegExp,
      YD: (s) => +s,
      YE: x0 => x0.getBoundingClientRect(),
      YF: x0 => x0.isConnected,
      YG: (handle) => clearInterval(handle),
      YH: (x0,x1) => x0.replaceWith(x1),
      YI: x0 => x0.naturalWidth,
      YJ: (o, p) => p in o,
      YK: x0 => x0.code,
      YL: x0 => x0.value,
      Z: (o0, o1, o2) => [o0, o1, o2],
      ZB: Function.prototype.call.bind(DataView.prototype.getFloat32),
      ZC: x0 => x0.dotAll,
      ZD: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      ZE: x0 => x0.y,
      ZF: x0 => x0.head,
      ZG: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      ZH: (x0,x1) => { x0.className = x1 },
      ZI: (x0,x1) => { x0.src = x1 },
      ZJ: x0 => x0.groups,
      ZK: x0 => x0.repeat,
      ZL: x0 => x0.done,
      a: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      aB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float32Array) return 1;
        return 2;
      },
      aC: x0 => x0.unicode,
      aD: s => s.trim(),
      aE: x0 => x0.x,
      aF: (x0,x1) => { x0.content = x1 },
      aG: () => Date.now(),
      aH: (x0,x1) => { x0.action = x1 },
      aI: x0 => x0.displayHeight,
      aJ: () => globalThis.window.navigator.userAgent,
      aK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      aL: x0 => x0.read(),
      b: (x0,x1,x2) => { x0[x1] = x2 },
      bB: Function.prototype.call.bind(DataView.prototype.getUint32),
      bC: x0 => x0.ignoreCase,
      bD: x0 => x0.classList,
      bE: x0 => x0.top,
      bF: (x0,x1) => { x0.name = x1 },
      bG: x0 => x0.debugSkipFontRetryDelay,
      bH: (x0,x1) => { x0.method = x1 },
      bI: x0 => x0.displayWidth,
      bJ: (x0,x1,x2) => x0.setAttribute(x1,x2),
      bK: (x0,x1) => x0.removeAttribute(x1),
      bL: x0 => x0.body,
      c: o => o,
      cB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint32Array) return 1;
        return 2;
      },
      cC: x0 => x0.multiline,
      cD: x0 => x0.relatedTarget,
      cE: x0 => x0.left,
      cF: (x0,x1) => x0.removeChild(x1),
      cG: x0 => x0.status,
      cH: (x0,x1) => { x0.noValidate = x1 },
      cI: x0 => x0.duration,
      cJ: (x0,x1) => { x0.height = x1 },
      cK: x0 => x0.load(),
      cL: (x0,x1) => new OffscreenCanvas(x0,x1),
      d: (o, p) => o[p],
      dB: Function.prototype.call.bind(DataView.prototype.getInt32),
      dC: (string, token) => string.split(token),
      dD: x0 => x0.hasFocus(),
      dE: x0 => x0.scrollTop,
      dF: x0 => x0.firstChild,
      dG: (x0,x1,x2) => x0.set(x1,x2),
      dH: x0 => x0.click(),
      dI: (x0,x1) => x0.decode(x1),
      dJ: (x0,x1) => { x0.width = x1 },
      dK: (x0,x1) => { x0.loop = x1 },
      dL: x0 => x0.assetBase,
      e: () => globalThis,
      eB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int32Array) return 1;
        return 2;
      },
      eC: (a, i) => a[i],
      eD: x0 => x0.shiftKey,
      eE: x0 => x0.offsetTop,
      eF: x0 => x0.viewConstraints,
      eG: x0 => x0.arrayBuffer(),
      eH: (x0,x1) => x0.getElementsByClassName(x1),
      eI: (x0,x1) => ({frameIndex: x0,completeFramesOnly: x1}),
      eJ: (x0,x1) => { x0.border = x1 },
      eK: (x0,x1) => { x0.volume = x1 },
      eL: x0 => x0.loader,
      f: (x0,x1) => ({addView: x0,removeView: x1}),
      fB: Function.prototype.call.bind(DataView.prototype.getUint16),
      fC: a => a.length,
      fD: x0 => x0.body,
      fE: x0 => x0.scrollLeft,
      fF: x0 => x0.hostElement,
      fG: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof ArrayBuffer) return 1;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 2;
        }
        return 3;
      },
      fH: (x0,x1) => x0.dispatchEvent(x1),
      fI: x0 => x0.image,
      fJ: x0 => x0.style,
      fK: (x0,x1) => { x0.muted = x1 },
      fL: () => globalThis._flutter,
      g: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gB: o => o instanceof Uint16Array,
      gC: o => o instanceof Array,
      gD: x0 => x0.visibilityState,
      gE: x0 => x0.offsetLeft,
      gF: x0 => ({runApp: x0}),
      gG: (x0,x1) => x0.fetch(x1),
      gH: (x0,x1) => x0.createEvent(x1),
      gI: x0 => x0.close(),
      gJ: (x0,x1) => { x0.src = x1 },
      gK: (x0,x1) => { x0.src = x1 },
      h: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      hB: Function.prototype.call.bind(DataView.prototype.getInt16),
      hC: (x0,x1) => x0[x1],
      hD: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      hE: x0 => x0.offsetParent,
      hF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      hG: x0 => x0.fontFallbackBaseUrl,
      hH: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      hI: x0 => new window.ImageDecoder(x0),
      hJ: (x0,x1) => x0.createElement(x1),
      hK: x0 => x0.message,
      i: (l, r) => l === r,
      iB: o => o instanceof Int16Array,
      iC: x0 => x0.index,
      iD: x0 => x0.disconnect(),
      iE: x0 => x0.offsetY,
      iF: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      iG: x0 => x0.language,
      iH: x0 => x0.readText(),
      iI: (x0,x1,x2,x3) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3}),
      iJ: () => globalThis.document,
      iK: x0 => x0.code,
      j: x0 => x0.random(),
      jB: o => o instanceof Uint8ClampedArray,
      jC: x0 => x0.userAgent,
      jD: x0 => new Intl.Locale(x0),
      jE: x0 => x0.offsetX,
      jF: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      jG: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      jH: x0 => x0.clipboard,
      jI: x0 => x0.name,
      jJ: (x0,x1,x2) => x0.postMessage(x1,x2),
      jK: x0 => x0.error,
      k: o => o,
      kB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint8Array) return 1;
        return 2;
      },
      kC: x0 => x0.navigator,
      kD: x0 => x0.region,
      kE: (o, p, r) => o.replace(p, () => r),
      kF: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      kG: x0 => x0.history,
      kH: (x0,x1) => x0.writeText(x1),
      kI: x0 => x0.repetitionCount,
      kJ: x0 => x0.contentWindow,
      kK: (x0,x1) => x0.start(x1),
      l: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'number') return 1;
        return 2;
      },
      lB: Function.prototype.call.bind(DataView.prototype.setInt32),
      lC: Function.prototype.call.bind(String.prototype.toLowerCase),
      lD: x0 => x0.script,
      lE: (o, p, r) => o.replaceAll(p, () => r),
      lF: () => typeof dartUseDateNowForTicks !== "undefined",
      lG: x0 => x0.search,
      lH: x0 => x0.unlock(),
      lI: x0 => x0.frameCount,
      lJ: (x0,x1) => { x0.allow = x1 },
      lK: (x0,x1) => x0.end(x1),
      m: () => globalThis.Math,
      mB: Function.prototype.call.bind(DataView.prototype.setUint32),
      mC: Object.is,
      mD: x0 => x0.language,
      mE: x0 => x0.deltaMode,
      mF: () => Date.now(),
      mG: x0 => x0.location,
      mH: (x0,x1) => x0.lock(x1),
      mI: x0 => x0.selectedTrack,
      mJ: (x0,x1) => { x0.id = x1 },
      mK: x0 => x0.length,
      n: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      nB: Function.prototype.call.bind(DataView.prototype.setInt16),
      nC: x0 => x0.vendor,
      nD: x0 => x0.languages,
      nE: x0 => x0.deltaY,
      nF: () => 1000 * performance.now(),
      nG: x0 => x0.pathname,
      nH: x0 => x0.orientation,
      nI: x0 => x0.completed,
      nJ: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      nK: x0 => x0.buffered,
      o: b => !!b,
      oB: Function.prototype.call.bind(DataView.prototype.setUint16),
      oC: (x0,x1) => x0.createTextNode(x1),
      oD: (x0,x1) => x0.observe(x1),
      oE: x0 => x0.deltaX,
      oF: (x0,x1) => x0.requestAnimationFrame(x1),
      oG: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      oH: (x0,x1) => x0.querySelector(x1),
      oI: x0 => x0.ready,
      oJ: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      oK: x0 => x0.videoWidth,
      p: () => globalThis.document,
      pB: Function.prototype.call.bind(DataView.prototype.setUint8),
      pC: (x0,x1) => { x0.id = x1 },
      pD: x0 => new ResizeObserver(x0),
      pE: x0 => x0.wheelDeltaY,
      pF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      pG: o => Object.keys(o),
      pH: (x0,x1) => { x0.title = x1 },
      pI: x0 => x0.tracks,
      pJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      pK: x0 => x0.videoHeight,
      q: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qB: Function.prototype.call.bind(DataView.prototype.setInt8),
      qC: (x0,x1) => { x0.nonce = x1 },
      qD: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      qE: x0 => x0.wheelDeltaX,
      qF: x0 => x0.now(),
      qG: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      qH: (x0,x1) => x0.vibrate(x1),
      qI: () => globalThis.window.ImageDecoder,
      qJ: x0 => x0.data,
      qK: x0 => x0.duration,
      r: (x0,x1) => x0.focus(x1),
      rB: Function.prototype.call.bind(DataView.prototype.getInt8),
      rC: x0 => x0.nonce,
      rD: (x0,x1) => x0.getPropertyValue(x1),
      rE: x0 => x0.bottom,
      rF: x0 => x0.performance,
      rG: x0 => x0.state,
      rH: x0 => x0.content,
      rI: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      rJ: () => globalThis.window,
      rK: (x0,x1) => { x0.playsInline = x1 },
      s: () => ({}),
      sB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int8Array) return 1;
        return 2;
      },
      sC: () => globalThis.window.flutterConfiguration,
      sD: x0 => globalThis.parseFloat(x0),
      sE: x0 => x0.right,
      sF: (x0,x1) => x0.decode(x1),
      sG: x0 => x0.hash,
      sH: x0 => x0.document,
      sI: (a, s, e) => a.slice(s, e),
      sJ: x0 => x0.id,
      sK: (x0,x1) => { x0.controls = x1 },
      t: (o, p, v) => o[p] = v,
      tB: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      tC: (x0,x1) => x0.attachShadow(x1),
      tD: (x0,x1) => x0.getComputedStyle(x1),
      tE: x0 => x0.clientY,
      tF: (x0,x1,x2) => x0.slice(x1,x2),
      tG: x0 => x0.state,
      tH: (a, i) => a.splice(i, 1),
      tI: x0 => x0.decode(),
      tJ: (x0,x1) => { x0.srcdoc = x1 },
      tK: (x0,x1) => { x0.autoplay = x1 },
      u: () => [],
      uB: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      uC: (x0,x1) => x0.createElement(x1),
      uD: x0 => x0.documentElement,
      uE: x0 => x0.clientX,
      uF: x0 => new Uint8Array(x0),
      uG: (x0,x1) => x0.go(x1),
      uH: a => a.pop(),
      uI: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      uJ: (x0,x1,x2) => x0.insertBefore(x1,x2),
      uK: x0 => x0.currentTime,
      v: (a, i) => a.push(i),
      vB: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      vC: x0 => x0.scale,
      vD: (x0,x1) => x0.get(x1),
      vE: x0 => x0.changedTouches,
      vF: (x0,x1) => x0.adoptText(x1),
      vG: (x0,x1) => x0.querySelectorAll(x1),
      vH: x0 => new WeakRef(x0),
      vI: (x0,x1,x2) => x0.addEventListener(x1,x2),
      vJ: x0 => x0.id,
      vK: (x0,x1) => { x0.playbackRate = x1 },
      w: x0 => new Int8Array(x0),
      wB: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      wC: x0 => x0.visualViewport,
      wD: x0 => x0.computedStyleMap(),
      wE: x0 => x0.key,
      wF: x0 => x0.first(),
      wG: (x0,x1) => x0.removeProperty(x1),
      wH: x0 => x0.deref(),
      wI: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      wJ: x0 => x0.offsetHeight,
      wK: x0 => x0.pause(),
      x: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      xB: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      xC: x0 => x0.devicePixelRatio,
      xD: (o, p) => p in o,
      xE: x0 => x0.identifier,
      xF: x0 => x0.next(),
      xG: (x0,x1) => x0.add(x1),
      xH: () => globalThis.WeakRef,
      xI: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      xJ: x0 => x0.offsetWidth,
      xK: x0 => x0.play(),
      y: x0 => new Uint8Array(x0),
      yB: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      yC: x0 => x0.height,
      yD: (x0,x1) => { x0.textContent = x1 },
      yE: x0 => x0.touches,
      yF: x0 => x0.current(),
      yG: x0 => x0.data,
      yH: (x0,x1) => x0.getRandomValues(x1),
      yI: x0 => x0.send(),
      yJ: x0 => x0.stopPropagation(),
      yK: x0 => x0.message,
      z: x0 => new Uint8ClampedArray(x0),
      zB: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      zC: x0 => x0.width,
      zD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      zE: x0 => x0.pressure,
      zF: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      zG: (x0,x1) => x0.removeAttribute(x1),
      zH: () => globalThis.crypto,
      zI: x0 => x0.status,
      zJ: x0 => x0.disabled,
      zK: x0 => x0.name,

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

    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
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
