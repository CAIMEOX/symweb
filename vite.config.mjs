import { spawn, spawnSync } from 'node:child_process'
import { mkdirSync, copyFileSync, existsSync } from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'
import { defineConfig } from 'vite'

const __dirname = path.dirname(fileURLToPath(import.meta.url))
const basePath = normalizeBasePath(process.env.SYMWEB_BASE_PATH ?? '/')
const moonJsArgs = ['build', 'cmd/web', '--target', 'js']
const moonWasmArgs = ['build', 'wasm_bridge', '--target', 'wasm-gc', '--release']
const moonJsOutput = path.join(
  __dirname,
  '_build',
  'js',
  'debug',
  'build',
  'cmd',
  'web',
  'web.js',
)
const moonWasmOutput = path.join(
  __dirname,
  '_build',
  'wasm-gc',
  'release',
  'build',
  'wasm_bridge',
  'wasm_bridge.wasm',
)
const generatedDir = path.join(__dirname, 'public', 'generated')
const generatedEntry = path.join(generatedDir, 'web.js')
const generatedKernel = path.join(generatedDir, 'symweb-kernel.wasm')

function normalizeBasePath(basePath) {
  if (basePath === '' || basePath === '/') {
    return '/'
  }
  let normalized = basePath
  if (!normalized.startsWith('/')) {
    normalized = `/${normalized}`
  }
  if (!normalized.endsWith('/')) {
    normalized = `${normalized}/`
  }
  return normalized
}

function runMoonBuild(args) {
  const result = spawnSync('moon', args, {
    cwd: __dirname,
    stdio: 'inherit',
  })
  if (result.status !== 0) {
    throw new Error(`MoonBit build failed: ${args.join(' ')}`)
  }
}

function syncMoonEntry() {
  if (!existsSync(moonJsOutput)) {
    throw new Error(`MoonBit JS output not found: ${moonJsOutput}`)
  }
  if (!existsSync(moonWasmOutput)) {
    throw new Error(`MoonBit wasm-gc output not found: ${moonWasmOutput}`)
  }
  mkdirSync(generatedDir, { recursive: true })
  copyFileSync(moonJsOutput, generatedEntry)
  copyFileSync(moonWasmOutput, generatedKernel)
}

function moonbitDevPlugin() {
  let isServe = false
  let moonJsWatcher = null
  let moonWasmWatcher = null

  const refreshGeneratedEntry = (server) => {
    try {
      syncMoonEntry()
      if (server) {
        server.ws.send({ type: 'full-reload' })
      }
    } catch (error) {
      console.error(error)
    }
  }

  const stopWatcher = () => {
    if (moonJsWatcher && !moonJsWatcher.killed) {
      moonJsWatcher.kill('SIGTERM')
      moonJsWatcher = null
    }
    if (moonWasmWatcher && !moonWasmWatcher.killed) {
      moonWasmWatcher.kill('SIGTERM')
      moonWasmWatcher = null
    }
  }

  return {
    name: 'moonbit-rabbita-dev',
    configResolved(config) {
      isServe = config.command === 'serve'
    },
    buildStart() {
      if (!isServe) {
        runMoonBuild(moonJsArgs)
        runMoonBuild(moonWasmArgs)
        syncMoonEntry()
      }
    },
    configureServer(server) {
      runMoonBuild(moonJsArgs)
      runMoonBuild(moonWasmArgs)
      syncMoonEntry()

      server.watcher.add(moonJsOutput)
      server.watcher.add(moonWasmOutput)
      server.watcher.on('change', (changedPath) => {
        const resolved = path.resolve(changedPath)
        if (
          resolved === path.resolve(moonJsOutput) ||
          resolved === path.resolve(moonWasmOutput)
        ) {
          refreshGeneratedEntry(server)
        }
      })

      moonJsWatcher = spawn('moon', [...moonJsArgs, '--watch'], {
        cwd: __dirname,
        stdio: 'inherit',
      })
      moonWasmWatcher = spawn('moon', [...moonWasmArgs, '--watch'], {
        cwd: __dirname,
        stdio: 'inherit',
      })

      process.on('exit', stopWatcher)
      process.on('SIGINT', () => {
        stopWatcher()
        process.exit(130)
      })
      process.on('SIGTERM', () => {
        stopWatcher()
        process.exit(143)
      })

      server.httpServer?.once('close', stopWatcher)
    },
  }
}

export default defineConfig({
  base: basePath,
  server: {
    open: true,
  },
  plugins: [moonbitDevPlugin()],
})
