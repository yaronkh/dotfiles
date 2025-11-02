#! /bin/bash

cd yasi || exit 1
cargo build --release --locked
mv target/release/yazi target/release/ya ~/dotfiles/build/bin/
