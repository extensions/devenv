FROM mcr.microsoft.com/vscode/devcontainers/universal:1-linux

USER root

ENV DENO_INSTALL=/deno \
    DENO_DIR=/deno/.cache/deno

RUN mkdir -p /deno \
    && curl -fsSL https://deno.land/x/install/install.sh | sh \
    && ln -s /deno/bin/deno /usr/bin/deno \
    && apt-get update && apt-get -y install ripgrep \
    && rustup toolchain add nightly beta \
    && rustup update \
    && rustup set profile default \
    && rustup target add wasm32-wasi wasm32-unknown-unknown \
    && cargo install sccache \
    && ln -s /workspaces /extensions \
    && ln -s /workspaces /x \
    && chown -R codespace /deno /usr/local

USER codespace

ENV RUSTC_WRAPPER=sccache

RUN cargo install cargo-edit cargo-expand cargo-udeps cargo-geiger wasm-bindgen-cli

COPY .devcontainer/profile.sh /home/codespace/.devenv.profile.sh

RUN deno install --allow-all --no-check --unstable https://deno.land/x/deploy/deployctl.ts \
    && deno cache --no-check https://deno.land/std/crypto/mod.ts \
    && echo source /home/codespace/.devenv.profile.sh | tee --append /home/codespace/.bashrc /home/codespace/.zshrc
