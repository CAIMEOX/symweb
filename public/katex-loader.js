(function() {
  const shellSelector = ".result-value-latex-shell";
  let scheduled = false;

  function renderShell(shell) {
    const sourceNode = shell.querySelector(".latex-source");
    const targetNode = shell.querySelector(".latex-render");
    if (!(sourceNode instanceof HTMLElement) || !(targetNode instanceof HTMLElement)) {
      return;
    }

    const source = (sourceNode.textContent || "").trim();
    if (source === "") {
      shell.classList.remove("katex-ready");
      shell.classList.remove("katex-failed");
      targetNode.textContent = "";
      targetNode.removeAttribute("data-latex-source");
      return;
    }

    const katexApi = globalThis.katex;
    if (!katexApi || typeof katexApi.render !== "function") {
      shell.classList.remove("katex-ready");
      shell.classList.add("katex-failed");
      return;
    }

    if (
      shell.classList.contains("katex-ready") &&
      targetNode.getAttribute("data-latex-source") === source
    ) {
      return;
    }

    try {
      katexApi.render(source, targetNode, {
        displayMode: true,
        output: "htmlAndMathml",
        throwOnError: false,
      });
      targetNode.setAttribute("data-latex-source", source);
      shell.classList.add("katex-ready");
      shell.classList.remove("katex-failed");
    } catch (error) {
      console.error("KaTeX render failed:", error);
      targetNode.textContent = "";
      targetNode.removeAttribute("data-latex-source");
      shell.classList.remove("katex-ready");
      shell.classList.add("katex-failed");
    }
  }

  function renderAll(root) {
    if (!(root instanceof Element || root instanceof Document)) {
      return;
    }
    root.querySelectorAll(shellSelector).forEach(renderShell);
  }

  function scheduleRender(root) {
    if (scheduled) {
      return;
    }
    scheduled = true;
    requestAnimationFrame(function() {
      scheduled = false;
      renderAll(root);
    });
  }

  function initKatexRendering() {
    const appRoot = document.getElementById("app");
    if (!appRoot) {
      return;
    }

    renderAll(appRoot);

    const observer = new MutationObserver(function() {
      scheduleRender(appRoot);
    });
    observer.observe(appRoot, {
      childList: true,
      subtree: true,
      characterData: true,
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initKatexRendering, {
      once: true,
    });
  } else {
    initKatexRendering();
  }
})();
