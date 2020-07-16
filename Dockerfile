FROM docker.io/alpine:3.12.0
ARG glfw_ver=3.3.2

RUN apk -U upgrade

# Install packages
RUN apk add curl p7zip unzip xxd	# Not directly dev-related
RUN apk add byacc flex git	# Dev-related but not compiler/build tool
RUN apk add cmake make	# Build tools
RUN apk add clang go mingw-w64-gcc	# Compilers
RUN apk add python3	# Interpreters
RUN apk add glfw-dev sdl2-dev	# Graphics libraries
RUN apk add libxcb-dev libxcb-static libx11-dev libx11-static	# X11 libraries
RUN apk add freetype-dev libev-dev	# Misc libraries

WORKDIR /tmp/docker_build

# Build glfw for mingw
RUN curl -LO https://github.com/glfw/glfw/releases/download/$glfw_ver/glfw-$glfw_ver.zip
RUN unzip glfw-$glfw_ver.zip
WORKDIR glfw-$glfw_ver
RUN cmake -DCMAKE_TOOLCHAIN_FILE=CMake/x86_64-w64-mingw32.cmake -DCMAKE_INSTALL_PREFIX=/usr/x86_64-w64-mingw32 .
RUN make -j$(nproc) install
WORKDIR ..

# Clean up builds
WORKDIR /
RUN rm -rf /tmp/docker_build

# Install emscripten
RUN apk add binaryen llvm nodejs	# emcc dependencies
WORKDIR /opt
RUN git clone --depth 1 -b 1.39.19 https://github.com/emscripten-core/emscripten
COPY .emscripten emscripten/
ENV PATH="${PATH}:/opt/emscripten"
WORKDIR /
RUN emcc -v	# Check it's operating correctly
