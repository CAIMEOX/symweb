(function() {
  const loaderUrl =
    document.currentScript instanceof HTMLScriptElement &&
    document.currentScript.src
      ? document.currentScript.src
      : document.baseURI;
  const kernelPath = new URL("./generated/symweb-kernel.wasm", loaderUrl).href;

  async function instantiateKernel() {
    if (typeof WebAssembly === "undefined") {
      throw new Error("WebAssembly is not available.");
    }
    const response = await fetch(kernelPath);
    if (!response.ok) {
      throw new Error(`Kernel fetch failed: ${response.status}`);
    }
    const imports = {
      spectest: {
        print_char() {},
      },
    };
    if (typeof WebAssembly.instantiateStreaming === "function") {
      try {
        return await WebAssembly.instantiateStreaming(response.clone(), imports);
      } catch (_) {
      }
    }
    const bytes = await response.arrayBuffer();
    return WebAssembly.instantiate(bytes, imports);
  }

  function createKernelFacade(instance) {
    if (typeof TextEncoder === "undefined" || typeof TextDecoder === "undefined") {
      throw new Error("UTF-8 text codecs are not available.");
    }
    const encoder = new TextEncoder();
    const decoder = new TextDecoder();
    const exports = instance.exports;
    const resetRequest = exports.kernel_reset_request;
    const pushRequestByte = exports.kernel_push_request_byte;
    const evaluateRequest = exports.kernel_evaluate_request;
    const resultLength = exports.kernel_result_length;
    const resultByte = exports.kernel_result_byte;
    if (
      typeof resetRequest !== "function" ||
      typeof pushRequestByte !== "function" ||
      typeof evaluateRequest !== "function" ||
      typeof resultLength !== "function" ||
      typeof resultByte !== "function"
    ) {
      throw new Error("Kernel exports are incomplete.");
    }
    return {
      runEvalJson(requestJson) {
        const requestBytes = encoder.encode(requestJson);
        resetRequest();
        for (let index = 0; index < requestBytes.length; index += 1) {
          pushRequestByte(requestBytes[index]);
        }
        const outputLength = evaluateRequest();
        const outputBytes = new Uint8Array(outputLength);
        for (let index = 0; index < outputLength; index += 1) {
          outputBytes[index] = resultByte(index);
        }
        return decoder.decode(outputBytes);
      },
    };
  }

  globalThis.__symwebKernel = null;
  globalThis.__symwebKernelError = "";
  globalThis.__symwebKernelReady = instantiateKernel()
    .then(({ instance }) => {
      globalThis.__symwebKernel = createKernelFacade(instance);
      return globalThis.__symwebKernel;
    })
    .catch((error) => {
      globalThis.__symwebKernelError =
        error instanceof Error ? error.message : String(error);
      return null;
    });
})();
