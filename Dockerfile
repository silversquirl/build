FROM docker.io/alpine:3.12.0
ENV glew_ver=2.1.0
ENV glfw_ver=3.3.2

WORKDIR /tmp/docker_build

RUN apk -U upgrade

# Install packages
RUN apk add \
	byacc clang cmake curl flex git go make \
	mingw-w64-gcc p7zip python3 unzip xxd \
	\
	freetype-dev libev-dev glew-dev glfw-dev sdl2-dev


# Build glew for mingw
RUN curl -LO https://sourceforge.net/projects/glew/files/glew/$glew_ver/glew-$glew_ver.zip
RUN unzip glew-$glew_ver.zip
WORKDIR glew-$glew_ver
RUN make -j$(nproc) install SYSTEM=linux-mingw64 HOST=x86_64-w64-mingw32 GLEW_DEST=/usr/x86_64-w64-mingw32 GLEW_PREFIX=/usr/x86_64-w64-mingw32
WORKDIR ..

# Build glfw for mingw
RUN curl -LO https://github.com/glfw/glfw/releases/download/$glfw_ver/glfw-$glfw_ver.zip
RUN unzip glfw-$glfw_ver.zip
WORKDIR glfw-$glfw_ver
RUN cmake -DCMAKE_TOOLCHAIN_FILE=CMake/x86_64-w64-mingw32.cmake -DCMAKE_INSTALL_PREFIX=/usr/x86_64-w64-mingw32 .
RUN make -j$(nproc) install
WORKDIR ..

# Clean up
WORKDIR /
RUN rm -rf /tmp/docker_build
