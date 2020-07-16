# vktec's build container

This is a container containing a selection of build tools, designed for use with
GitHub Actions and [cinsh]. This container is based on Alpine Linux, which uses
musl libc. As such, it is recommended to statically link any binaries produced
using this image.

[cinsh]: https://github.com/vktec/cinsh

## Packages

This container includes a selection of build tools and language interpreters:

- byacc
- clang
- cmake
- curl
- emscripten
- flex
- git
- golang
- make
- mingw
- p7zip
- python3
- unzip
- xxd

As well as a selection of libraries for linking against:

- FreeType
- GLEW
- GLFW3
- SDL2
- libev
