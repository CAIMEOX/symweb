(function() {
  const kernelPath = "/generated/symweb-kernel.wasm";
  const compileOptions = {
    builtins: ["js-string"],
    importedStringConstants: "_",
  };

  async function instantiateKernel() {
    if (typeof WebAssembly === "undefined") {
      throw new Error("WebAssembly is not available.");
    }
    const imports = { _: {} };
    if (typeof WebAssembly.instantiateStreaming === "function") {
      const response = await fetch(kernelPath);
      if (!response.ok) {
        throw new Error(`Kernel fetch failed: ${response.status}`);
      }
      return WebAssembly.instantiateStreaming(response, imports, compileOptions);
    }
    const response = await fetch(kernelPath);
    if (!response.ok) {
      throw new Error(`Kernel fetch failed: ${response.status}`);
    }
    const bytes = await response.arrayBuffer();
    return WebAssembly.instantiate(bytes, imports, compileOptions);
  }

  globalThis.__symwebKernel = null;
  globalThis.__symwebKernelError = "";
  globalThis.__symwebKernelReady = instantiateKernel()
    .then(({ instance }) => {
      globalThis.__symwebKernel = {
        runEvalJson: instance.exports.run_eval_json,
      };
      return globalThis.__symwebKernel;
    })
    .catch((error) => {
      globalThis.__symwebKernelError =
        error instanceof Error ? error.message : String(error);
      return null;
    });
})();
