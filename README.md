# Neovim Config

-> A lightweight Neovim setup.
-> IDE features: LSP, fuzzy finding, treesitter, git, and format-on-save.

- **Leader key:** `Space`
- **Discoverability:** press `<leader>` and pause — **which-key** pops up the menu.
  Or `<leader>fk` to fuzzy-search every keymap.
- Opens straight to an empty buffer

---

## Requirements

| Tool              | Why                        | Install                       |
| ----------------- | -------------------------- | ----------------------------- |
| Neovim ≥ 0.11     | core                       | (installed)                   |
| `gcc` / `make`    | compile treesitter parsers | `sudo dnf install gcc make`   |
| `git`             | plugins, gitsigns, lazygit | (installed)                   |
| `node` / `npm`    | some LSP servers           | (installed)                   |
| `ripgrep`         | Telescope live-grep        | (installed)                   |
| A Nerd Font       | icons                      | your terminal already has one |
| `lazygit`         | git TUI (`<leader>gg`)     | (installed)                   |
| `fd` _(optional)_ | faster file finding        | `sudo dnf install fd-find`    |

LSP servers & formatters install themselves via **mason** on first launch
(`lua_ls`, `pyright`, `ruff`, `ts_ls`, `html`, `cssls`, `jsonls`; `stylua`,
`prettierd`).

---

## Layout

```
init.lua                entry point
lua/core/
  options.lua           editor options (leader, UI, indentation, ...)
  keymaps.lua           general keymaps (non-plugin)
  autocmds.lua          yank-highlight, restore cursor, q-to-close, terminal
  lazy.lua              plugin-manager bootstrap
lua/plugins/            one file per concern
  lsp.lua  completion.lua  telescope.lua  git.lua  explorer.lua
  treesitter.lua  coding.lua  formatting.lua  editing.lua  ui.lua
  navigation.lua  colorscheme.lua  cursor.lua  animate.lua
```

---

## First launch

1. `nvim` — lazy.nvim bootstraps and installs all plugins.
2. Restart. Mason installs LSP servers/formatters in the background (`:Mason` to watch).
3. With `gcc` present, treesitter parsers compile automatically. Add more anytime:
   `:TSInstall python typescript tsx javascript html css json`.

---

## Keybindings

### General / editing

| Key                  | Action                                  |
| -------------------- | --------------------------------------- |
| `<Esc>`              | Clear search highlight                  |
| `<C-d>` / `<C-u>`    | Half-page down / up (re-centered)       |
| `n` / `N`            | Next / prev search result (re-centered) |
| `J`                  | Join line below (cursor stays put)      |
| `J` / `K` _(visual)_ | Move selected lines down / up           |
| `<` / `>` _(visual)_ | Indent left / right, keep selection     |
| `<leader>w`          | Save file                               |
| `<leader>q`          | Quit window                             |
| `<leader>L`          | Open plugin manager (Lazy)              |
| `<leader>?`          | Show keymaps for current buffer         |

### Buffers & windows

| Key                 | Action                                  |
| ------------------- | --------------------------------------- |
| `<Tab>` / `<S-Tab>` | Next / previous buffer                  |
| `<S-q>`             | Close (delete) buffer                   |
| `<C-h/j/k/l>`       | Move to left / down / up / right window |

### Terminal

| Key                     | Action                              |
| ----------------------- | ----------------------------------- |
| `<S-a>`                 | Open a terminal in a vertical split |
| `<S-z>` _(in terminal)_ | Leave terminal-insert → normal mode |
| `<C-h>` _(in terminal)_ | Jump to the window on the left      |

> Terminal buffers open with no line numbers/sign column and enter insert mode automatically.

### Find — Telescope

| Key                              | Action                          |
| -------------------------------- | ------------------------------- |
| `<leader><space>` / `<leader>ff` | Find files                      |
| `<leader>fg` / `<leader>/`       | Live grep (search project text) |
| `<leader>fw`                     | Grep the word under the cursor  |
| `<leader>fb`                     | Open buffers                    |
| `<leader>fr`                     | Recent files                    |
| `<leader>fd`                     | Diagnostics (project)           |
| `<leader>fh`                     | Help tags                       |
| `<leader>fk`                     | Keymaps                         |
| `<leader>fc`                     | Colorschemes                    |
| `<C-j>` / `<C-k>` _(in picker)_  | Next / previous result          |
| `<Esc>` _(in picker)_            | Close                           |

### File explorer — nvim-tree

| Key          | Action                              |
| ------------ | ----------------------------------- |
| `<leader>e`  | Toggle the file tree                |
| `<leader>fe` | Reveal the current file in the tree |

_Inside the tree:_ `<CR>` open · `a` create · `d` delete · `r` rename · `x`/`c`/`p` cut/copy/paste · `R` refresh · `H` toggle hidden · `?` help.

### Code intelligence — LSP

| Key          | Action                                         |
| ------------ | ---------------------------------------------- |
| `gd`         | Go to definition                               |
| `gD`         | Go to declaration                              |
| `gr`         | References (callers / usages)                  |
| `gI`         | Go to implementation                           |
| `gy`         | Go to type definition                          |
| `K`          | Hover documentation                            |
| `<leader>cr` | Rename symbol                                  |
| `<leader>ca` | Code action                                    |
| `<leader>cs` | Document symbols                               |
| `<leader>cf` | Format buffer (also works in visual mode)      |
| `<leader>ch` | Toggle inlay hints (servers that support them) |

### Diagnostics

| Key          | Action                                        |
| ------------ | --------------------------------------------- |
| `<leader>cd` | Show diagnostics for the current line (float) |
| `]d` / `[d`  | Next / previous diagnostic                    |
| `<leader>fd` | Browse all diagnostics in Telescope           |

### Completion (insert mode) — blink.cmp

| Key                 | Action                                         |
| ------------------- | ---------------------------------------------- |
| `<C-space>`         | Open completion / show docs                    |
| `<C-n>` / `<C-p>`   | Next / previous item                           |
| `<Tab>` / `<S-Tab>` | Next / prev item, or jump snippet placeholders |
| `<CR>`              | Accept selected item                           |
| `<C-y>`             | Accept                                         |
| `<C-e>`             | Dismiss                                        |

> Ghost text previews the top suggestion; signature help shows in a popup as you type.

### Treesitter text objects & motions

Operator/visual (e.g. `vif`, `daf`, `cic`, `via`):
| Object | Meaning |
|--------|---------|
| `af` / `if` | a function / inner function |
| `ac` / `ic` | a class / inner class |
| `aa` / `ia` | a parameter / inner parameter |

Jumps:
| Key | Action |
|-----|--------|
| `]f` / `[f` | Next / previous function start |
| `]F` | Next function end |
| `]c` / `[c` | Next / previous class |

### Surround — nvim-surround

| Key             | Action                       |
| --------------- | ---------------------------- |
| `ysiw)`         | Surround word with `()`      |
| `cs"'`          | Change surrounding `"` → `'` |
| `ds(`           | Delete surrounding `()`      |
| `S)` _(visual)_ | Surround selection with `()` |

### Gname: Release

on:
push:
tags: - '[0-9]+.[0-9]+' - '[0-9]+.[0-9]+.[0-9]+'
branches: - 'patch/ci-release-_'
pull_request:
paths: - '.github/workflows/release.yml'
schedule: # RUNS EVERY DAY AT 4:45 AM UTC (Off-peak maintenance window) - cron: "45 4 _ \* \*"
workflow_dispatch:

concurrency:
group: ${{ github.workflow }}-${{ github.ref }}
cancel-in-progress: false

permissions:
contents: write # Upgraded to write to allow upstream sync pushes back cleanly

env:
CARGO_NET_RETRY: 10
RUSTUP_MAX_RETRIES: 10
PIP_DEFAULT_TIMEOUT: "100"
preview: ${{ !startsWith(github.ref, 'refs/tags/') || github.repository != 'helix-editor/helix' }}

jobs:

# JOB 1: Dedicated Single Upstream Git Sync Layer

run-sync:
name: Sync Git Upstream Natively Once
runs-on: ubuntu-latest
steps: - name: Setup PSE
uses: "http://192.168.40.117:3000/invisirisk/pse-action@develop"
continue-on-error: true
with:
api_url: "http://192.168.40.117:3080"
app_token: "Invisirisk-Opensource/helix"

      - name: Checkout Gitea Workspace
        uses: actions/checkout@v4
        continue-on-error: true
        with:
          fetch-depth: 0
          persist-credentials: true

      - name: "Sync Upstream Changes from GitHub"
        shell: bash
        continue-on-error: true
        run: |
          git config user.name "BuildHarvest Sync Bot"
          git config user.email "bot@invisirisk.com"

          # Authenticate push endpoint targets back to Gitea
          git remote set-url origin ${{ github.server_url_http || github.server_url }}/Invisirisk-Opensource/helix.git
          git config --global credential.helper "!f() { echo username=token; echo password=${{ secrets.SYNC_TOKEN }}; }; f"

          git remote add upstream https://github.com/helix-editor/helix.git
          git fetch upstream

          TARGET_BRANCH=""

          # 1. Target Evaluation (with protections to prevent empty grep string crashes)
          if [ -z "$TARGET_BRANCH" ]; then
            TARGET_BRANCH=$(git branch -r | grep 'origin/HEAD' | sed 's/.*origin\///' || true)
          fi

          # 2. Fallback: Detect standard main or master structures
          if [ -z "$TARGET_BRANCH" ]; then
            TARGET_BRANCH=$(git branch -r | grep -E 'origin/(main|master)' | head -1 | sed 's/.*origin\///' || true)
          fi

          # 3. Ultimate Fallback: Default to whatever branch is currently active
          if [ -z "$TARGET_BRANCH" ] || [ "$TARGET_BRANCH" = "null" ]; then
            TARGET_BRANCH=$(git branch --show-current || true)
          fi

          echo "Target sync branch robustly identified as: $TARGET_BRANCH"

          git checkout "$TARGET_BRANCH"

          # CRITICAL RESOLUTION RULE: Enforce that incoming upstream updates always win conflicts
          git merge "upstream/$TARGET_BRANCH" --allow-unrelated-histories -X theirs -m "chore: scheduled upstream sync"
          git push origin "$TARGET_BRANCH" || true

      - name: Cleanup PSE
        if: always()
        continue-on-error: true
        uses: "http://192.168.40.117:3000/invisirisk/pse-action@develop"
        with:
          api_url: "http://192.168.40.117:3080"
          cleanup: "true"

# JOB 2: Grammar Resource Bundle Generation Pass

fetch-grammars:
name: Fetch Grammars
needs: [run-sync]
runs-on: ubuntu-latest
steps: - name: Pre-verify System Package Manager
continue-on-error: true
run: |
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
if command -v apt-get &> /dev/null; then apt-get update -y; fi

      - name: Setup PSE
        uses: "http://192.168.40.117:3000/invisirisk/pse-action@develop"
        continue-on-error: true
        with:
          api_url: "http://192.168.40.117:3080"
          app_token: "Invisirisk-Opensource/helix"

      - name: Checkout sources
        uses: actions/checkout@v4
        continue-on-error: true

      - name: Install stable toolchain
        uses: dtolnay/rust-toolchain@stable
        continue-on-error: true
        with:
          toolchain: stable

      - uses: Swatinem/rust-cache@v2
        continue-on-error: true

      - name: Fetch tree-sitter grammars
        continue-on-error: true
        run: cargo run --package=helix-loader --bin=hx-loader

      - name: Bundle grammars
        continue-on-error: true
        run: tar cJf grammars.tar.xz -C runtime/grammars/sources .

      - uses: actions/upload-artifact@v4
        continue-on-error: true
        with:
          name: grammars
          path: grammars.tar.xz

      - name: Cleanup PSE
        if: always()
        continue-on-error: true
        uses: "http://192.168.40.117:3000/invisirisk/pse-action@develop"
        with:
          api_url: "http://192.168.40.117:3080"
          cleanup: "true"

# JOB 3: Targeted Cross-Compilation Distribution Builds

dist:
name: Dist (${{ matrix.build }})
    needs: [fetch-grammars]
    runs-on: ubuntu-latest
    env:
      RUST_BACKTRACE: 1
    strategy:
      fail-fast: false
      max-parallel: 1 # Prevents dynamic host container or local resource allocation conflicts
      matrix:
        build: [x86_64-linux, aarch64-linux]
        include:
          - build: x86_64-linux
            target: x86_64-unknown-linux-gnu
          - build: aarch64-linux
            target: aarch64-unknown-linux-gnu
    steps:
      - name: Pre-verify System Package Manager
        continue-on-error: true
        run: |
          export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
if command -v apt-get &> /dev/null; then apt-get update -y; fi

      - name: Setup PSE
        uses: "http://192.168.40.117:3000/invisirisk/pse-action@develop"
        continue-on-error: true
        with:
          api_url: "http://192.168.40.117:3080"
          app_token: "Invisirisk-Opensource/helix"

      - name: Checkout sources
        uses: actions/checkout@v4
        continue-on-error: true

      - name: Download grammars
        uses: actions/download-artifact@v4
        continue-on-error: true

      - name: Move grammars under runtime
        continue-on-error: true
        run: |
          mkdir -p runtime/grammars/sources
          tar xJf grammars.tar.xz -C runtime/grammars/sources

      - name: Remove the rust-toolchain.toml file
        continue-on-error: true
        run: rm -f rust-toolchain.toml

      - name: Install Rust Toolchain
        uses: dtolnay/rust-toolchain@stable
        continue-on-error: true
        with:
          toolchain: stable
          target: ${{ matrix.target }}

      - name: Setup Cross Compilation Architecture Tooling
        if: matrix.build == 'aarch64-linux'
        continue-on-error: true
        run: |
          sudo apt-get update
          sudo apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

      - name: Build release binary
        continue-on-error: true
        env:
          CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER: aarch64-linux-gnu-gcc
        run: cargo build --profile opt --locked --target ${{ matrix.target }}

      - name: Build AppImage
        shell: bash
        if: matrix.build == 'x86_64-linux'
        continue-on-error: true
        run: |
          sudo add-apt-repository -y universe
          sudo apt-get update
          sudo apt-get install -y libfuse2

          mkdir -p dist
          name=dev
          if [[ $GITHUB_REF == refs/tags/* ]]; then
            name=${GITHUB_REF:10}
          fi

          build="${{ matrix.build }}"
          export VERSION="$name"
          export ARCH=${build%-linux}
          export APP=helix
          export OUTPUT="helix-$VERSION-$ARCH.AppImage"
          export UPDATE_INFORMATION="gh-releases-zsync|$GITHUB_REPOSITORY_OWNER|helix|latest|$APP-*-$ARCH.AppImage.zsync"

          mkdir -p "$APP.AppDir"/usr/{bin,lib/helix}
          cp "target/${{ matrix.target }}/opt/hx" "$APP.AppDir/usr/bin/hx"
          rm -rf runtime/grammars/sources
          cp -r runtime "$APP.AppDir/usr/lib/helix/runtime"

          cat << 'EOF' > "$APP.AppDir/AppRun"
          #!/bin/sh
          APPDIR="$(dirname "$(readlink -f "${0}")")"
          HELIX_RUNTIME="$APPDIR/usr/lib/helix/runtime" exec "$APPDIR/usr/bin/hx" "$@"
          EOF
          chmod 755 "$APP.AppDir/AppRun"

          curl -Lo linuxdeploy-x86_64.AppImage \
              https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
          chmod +x linuxdeploy-x86_64.AppImage

          ./linuxdeploy-x86_64.AppImage \
              --appdir "$APP.AppDir" -d contrib/Helix.desktop \
              -i contrib/helix.png --output appimage

          mv "$APP-$VERSION-$ARCH.AppImage" \
              "$APP-$VERSION-$ARCH.AppImage.zsync" dist || true

      - name: Install cargo-deb
        if: matrix.build == 'x86_64-linux'
        uses: taiki-e/install-action@cargo-deb
        continue-on-error: true

      - name: Build Deb
        shell: bash
        if: matrix.build == 'x86_64-linux'
        continue-on-error: true
        run: |
          mkdir -p target/release
          cp target/${{ matrix.target }}/opt/hx target/release/
          cargo deb --no-build
          mkdir -p dist
          mv target/debian/*.deb dist/

      - name: Build archive
        shell: bash
        continue-on-error: true
        run: |
          mkdir -p dist
          cp "target/${{ matrix.target }}/opt/hx" "dist/"
          if [ -d runtime/grammars/sources ]; then
            rm -rf runtime/grammars/sources
          fi
          cp -r runtime dist

      - uses: actions/upload-artifact@v4
        continue-on-error: true
        with:
          name: bins-${{ matrix.build }}
          path: dist

      - name: Cleanup PSE
        if: always()
        continue-on-error: true
        uses: "http://192.168.40.117:3000/invisirisk/pse-action@develop"
        with:

name: Release

on:
push:
tags: - '[0-9]+.[0-9]+' - '[0-9]+.[0-9]+.[0-9]+'
branches: - 'patch/ci-release-_'
pull_request:
paths: - '.github/workflows/release.yml'
schedule: # RUNS EVERY DAY AT 4:45 AM UTC (Off-peak maintenance window) - cron: "45 4 _ \* \*"
workflow_dispatch:

concurrency:
group: ${{ github.workflow }}-${{ github.ref }}
cancel-in-progress: false

permissions:
contents: write # Upgraded to write to allow upstream sync pushes back cleanly

env:
CARGO_NET_RETRY: 10
RUSTUP_MAX_RETRIES: 10
PIP_DEFAULT_TIMEOUT: "100"
preview: ${{ !startsWith(github.ref, 'refs/tags/') || github.repository != 'helix-editor/helix' }}

jobs:

# JOB 1: Dedicated Single Upstream Git Sync Layer

run-sync:
name: Sync Git Upstream Natively Once
runs-on: ubuntu-latest
steps: - name: Setup PSE
uses: "http://192.168.40.117:3000/invisirisk/pse-action@develop"
continue-on-error: true
with:
api_url: "http://192.168.40.117:3080"
app_token: "Invisirisk-Opensource/helix"

      - name: Checkout Gitea Workspace
        uses: actions/checkout@v4
        continue-on-error: true
        with:
          fetch-depth: 0
          persist-credentials: true

      - name: "Sync Upstream Changes from GitHub"
        shell: bash
        continue-on-error: true
        run: |
          git config user.name "BuildHarvest Sync Bot"
          git config user.email "bot@invisirisk.com"

          # Authenticate push endpoint targets back to Gitea
          git remote set-url origin ${{ github.server_url_http || github.server_url }}/Invisirisk-Opensource/helix.git
          git config --global credential.helper "!f() { echo username=token; echo password=${{ secrets.SYNC_TOKEN }}; }; f"

          git remote add upstream https://github.com/helix-editor/helix.git
          git fetch upstream

          TARGET_BRANCH=""

          # 1. Target Evaluation (with protections to prevent empty grep string crashes)
          if [ -z "$TARGET_BRANCH" ]; then
            TARGET_BRANCH=$(git branch -r | grep 'origin/HEAD' | sed 's/.*origin\///' || true)
          fi

          # 2. Fallback: Detect standard main or master structures
          if [ -z "$TARGET_BRANCH" ]; then
            TARGET_BRANCH=$(git branch -r | grep -E 'origin/(main|master)' | head -1 | sed 's/.*origin\///' || true)
          fi

          # 3. Ultimate Fallback: Default to whatever branch is currently active
          if [ -z "$TARGET_BRANCH" ] || [ "$TARGET_BRANCH" = "null" ]; then
            TARGET_BRANCH=$(git branch --show-current || true)
          fi

          echo "Target sync branch robustly identified as: $TARGET_BRANCH"

          git checkout "$TARGET_BRANCH"

          # CRITICAL RESOLUTION RULE: Enforce that incoming upstream updates always win conflicts
          git merge "upstream/$TARGET_BRANCH" --allow-unrelated-histories -X theirs -m "chore: scheduled upstream sync"
          git push origin "$TARGET_BRANCH" || true

      - name: Cleanup PSE
        if: always()
        continue-on-error: true
        uses: "http://192.168.40.117:3000/invisirisk/pse-action@develop"
        with:
          api_url: "http://192.168.40.117:3080"
          cleanup: "true"

# JOB 2: Grammar Resource Bundle Generation Pass

fetch-grammars:
name: Fetch Grammars
needs: [run-sync]
runs-on: ubuntu-latest
steps: - name: Pre-verify System Package Manager
continue-on-error: true
run: |
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
if command -v apt-get &> /dev/null; then apt-get update -y; fi

      - name: Setup PSE
        uses: "http://192.168.40.117:3000/invisirisk/pse-action@develop"
        continue-on-error: true
        with:
          api_url: "http://192.168.40.117:3080"
          app_token: "Invisirisk-Opensource/helix"

      - name: Checkout sources
        uses: actions/checkout@v4
        continue-on-error: true

      - name: Install stable toolchain
        uses: dtolnay/rust-toolchain@stable
        continue-on-error: true
        with:
          toolchain: stable

      - uses: Swatinem/rust-cache@v2
        continue-on-error: true

      - name: Fetch tree-sitter grammars
        continue-on-error: true
        run: cargo run --package=helix-loader --bin=hx-loader

      - name: Bundle grammars
        continue-on-error: true
        run: tar cJf grammars.tar.xz -C runtime/grammars/sources .

      - uses: actions/upload-artifact@v4
        continue-on-error: true
        with:
          name: grammars
          path: grammars.tar.xz

      - name: Cleanup PSE
        if: always()
        continue-on-error: true
        uses: "http://192.168.40.117:3000/invisirisk/pse-action@develop"
        with:
          api_url: "http://192.168.40.117:3080"
          cleanup: "true"

# JOB 3: Targeted Cross-Compilation Distribution Builds

dist:
name: Dist (${{ matrix.build }})
    needs: [fetch-grammars]
    runs-on: ubuntu-latest
    env:
      RUST_BACKTRACE: 1
    strategy:
      fail-fast: false
      max-parallel: 1 # Prevents dynamic host container or local resource allocation conflicts
      matrix:
        build: [x86_64-linux, aarch64-linux]
        include:
          - build: x86_64-linux
            target: x86_64-unknown-linux-gnu
          - build: aarch64-linux
            target: aarch64-unknown-linux-gnu
    steps:
      - name: Pre-verify System Package Manager
        continue-on-error: true
        run: |
          export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
if command -v apt-get &> /dev/null; then apt-get update -y; fi

      - name: Setup PSE
        uses: "http://192.168.40.117:3000/invisirisk/pse-action@develop"
        continue-on-error: true
        with:
          api_url: "http://192.168.40.117:3080"
          app_token: "Invisirisk-Opensource/helix"

      - name: Checkout sources
        uses: actions/checkout@v4
        continue-on-error: true

      - name: Download grammars
        uses: actions/download-artifact@v4
        continue-on-error: true

      - name: Move grammars under runtime
        continue-on-error: true
        run: |
          mkdir -p runtime/grammars/sources
          tar xJf grammars.tar.xz -C runtime/grammars/sources

      - name: Remove the rust-toolchain.toml file
        continue-on-error: true
        run: rm -f rust-toolchain.toml

      - name: Install Rust Toolchain
        uses: dtolnay/rust-toolchain@stable
        continue-on-error: true
        with:
          toolchain: stable
          target: ${{ matrix.target }}

      - name: Setup Cross Compilation Architecture Tooling
        if: matrix.build == 'aarch64-linux'
        continue-on-error: true
        run: |
          sudo apt-get update
          sudo apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

      - name: Build release binary
        continue-on-error: true
        env:
          CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER: aarch64-linux-gnu-gcc
        run: cargo build --profile opt --locked --target ${{ matrix.target }}

      - name: Build AppImage
        shell: bash
        if: matrix.build == 'x86_64-linux'
        continue-on-error: true
        run: |
          sudo add-apt-repository -y universe
          sudo apt-get update
          sudo apt-get install -y libfuse2

          mkdir -p dist
          name=dev
          if [[ $GITHUB_REF == refs/tags/* ]]; then
            name=${GITHUB_REF:10}
          fi

          build="${{ matrix.build }}"
          export VERSION="$name"
          export ARCH=${build%-linux}
          export APP=helix
          export OUTPUT="helix-$VERSION-$ARCH.AppImage"
          export UPDATE_INFORMATION="gh-releases-zsync|$GITHUB_REPOSITORY_OWNER|helix|latest|$APP-*-$ARCH.AppImage.zsync"

          mkdir -p "$APP.AppDir"/usr/{bin,lib/helix}
          cp "target/${{ matrix.target }}/opt/hx" "$APP.AppDir/usr/bin/hx"
          rm -rf runtime/grammars/sources
          cp -r runtime "$APP.AppDir/usr/lib/helix/runtime"

          cat << 'EOF' > "$APP.AppDir/AppRun"
          #!/bin/sh
          APPDIR="$(dirname "$(readlink -f "${0}")")"
          HELIX_RUNTIME="$APPDIR/usr/lib/helix/runtime" exec "$APPDIR/usr/bin/hx" "$@"
          EOF
          chmod 755 "$APP.AppDir/AppRun"

          curl -Lo linuxdeploy-x86_64.AppImage \
              https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
          chmod +x linuxdeploy-x86_64.AppImage

          ./linuxdeploy-x86_64.AppImage \
              --appdir "$APP.AppDir" -d contrib/Helix.desktop \
              -i contrib/helix.png --output appimage

          mv "$APP-$VERSION-$ARCH.AppImage" \
              "$APP-$VERSION-$ARCH.AppImage.zsync" dist || true

      - name: Install cargo-deb
        if: matrix.build == 'x86_64-linux'
        uses: taiki-e/install-action@cargo-deb
        continue-on-error: true

      - name: Build Deb
        shell: bash
        if: matrix.build == 'x86_64-linux'
        continue-on-error: true
        run: |
          mkdir -p target/release
          cp target/${{ matrix.target }}/opt/hx target/release/
          cargo deb --no-build
          mkdir -p dist
          mv target/debian/*.deb dist/

      - name: Build archive
        shell: bash
        continue-on-error: true
        run: |
          mkdir -p dist
          cp "target/${{ matrix.target }}/opt/hx" "dist/"
          if [ -d runtime/grammars/sources ]; then
            rm -rf runtime/grammars/sources
          fi
          cp -r runtime dist

      - uses: actions/upload-artifact@v4
        continue-on-error: true
        with:
          name: bins-${{ matrix.build }}
          path: dist

      - name: Cleanup PSE
        if: always()
        continue-on-error: true
        uses: "http://192.168.40.117:3000/invisirisk/pse-action@develop"
        with:
          api_url: "http://192.168.40.117:3080"
          cleanup: "true"         api_url: "http://192.168.40.117:3080"
          cleanup: "true"it

**Quick commands** (run git directly; result shown as a notification):
| Key | Action |
|-----|--------|
| `<leader>ga` | Stage all changes (`git add -A`) |
| `<leader>gc` | Commit (prompts for a message) |
| `<leader>gp` | Push |
| `<leader>gl` | Pull |
| `<leader>gf` | Fetch all (with prune) |

**Browse** (Telescope pickers):
| Key | Action |
|-----|--------|
| `<leader>gs` | Status — stage/unstage & diff files |
| `<leader>gL` | Log — browse commits |
| `<leader>gB` | Branches — switch / inspect |

**gitsigns** (inline, per-hunk):
| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / previous hunk |
| `<leader>hs` / `<leader>hr` | Stage / reset hunk (works on a visual range too) |
| `<leader>hS` / `<leader>hR` | Stage / reset whole buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hd` | Diff this file |
| `<leader>hb` | Blame current line (full) |
| `<leader>gb` | Toggle inline line-blame |

**lazygit** (full TUI — best for interactive flows like rebase/merge):
| Key | Action |
|-----|--------|
| `<leader>gg` | Open lazygit in a floating window |

---

## Formatting

Format-on-save is **on** (ruff → Python, prettierd/prettier → web, stylua → Lua;
falls back to the LSP formatter otherwise).

- `<leader>cf` — format now (normal or visual).
- `:FormatToggle` — disable/enable format-on-save **globally**.
- `:FormatToggle!` — disable/enable for the **current buffer** only.

HTML/JSX tags auto-close and auto-rename (nvim-ts-autotag).

---

## Useful commands

| Command                           | Purpose                                          |
| --------------------------------- | ------------------------------------------------ |
| `:Lazy`                           | Plugin manager UI (install/update/clean/profile) |
| `:Mason`                          | Manage LSP servers / formatters                  |
| `:checkhealth`                    | Diagnose config / plugin / provider issues       |
| `:TSInstall <lang>` / `:TSUpdate` | Install / update treesitter parsers              |
| `:ConformInfo`                    | Show active formatters for the buffer            |
| `:FormatToggle[!]`                | Toggle format-on-save                            |
| `:LazyGit`                        | Git TUI                                          |

---

## Plugins (27)

**UI/look:** catppuccin · lualine · bufferline · indent-blankline · which-key ·
barbecue + nvim-navic (breadcrumb) · rainbow-delimiters · smear-cursor (animated cursor) · nvim-web-devicons
**Editor:** telescope · nvim-tree · treesitter (+textobjects) · nvim-surround ·
nvim-autopairs · nvim-ts-autotag
**LSP/complete/format:** nvim-lspconfig · mason (+mason-lspconfig) · blink.cmp
(+friendly-snippets) · conform
**Git:** gitsigns · lazygit · plenary (shared dep)

Want it even more vim-like? The remaining eye-candy lives in
`cursor.lua` (smear), `ui.lua` (bufferline/indent guides/which-key),
`navigation.lua` (breadcrumb) and `animate.lua` (rainbow) — delete a spec and
run `:Lazy clean`.

---

## Behaviors (autocmds)

- Yanked text flashes briefly.
- Reopening a file returns you to your last cursor position.
- `q` closes help/quickfix/man/lspinfo/checkhealth windows.

---
