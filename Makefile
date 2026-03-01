# llvm-wasm: Compile LLVM
LLVM_TAG := llvmorg-22.1.0

LLVM_TARGETS_TO_BUILD := "AArch64;RISCV;SPIRV;WebAssembly;X86"

# cmake 参数
A := -S ../../llvm-project/llvm \
	-DCMAKE_BUILD_TYPE=Release \
	-DLLVM_TARGETS_TO_BUILD=$(LLVM_TARGETS_TO_BUILD) \
	-DLLVM_ENABLE_PROJECTS=lld

G := -G Ninja

CMAKE_BUILD := --build . --target llc lld

# 清理编译
clean:
	- rm -r build
.PHONY: clean

# 下载 LLVM 代码
clone-llvm:
	git clone https://github.com/llvm/llvm-project \
	--branch=$(LLVM_TAG) \
	--single-branch --depth=1
.PHONY: clone-llvm

# 复制编译后的文件, 并 strip
copy-strip:
	mkdir -p $(DIR_LLVM)
	cp $(DIR_BUILD)/bin/llc \
		$(DIR_BUILD)/bin/lld \
		$(DIR_LLVM)/

	llvm-strip $(DIR_LLVM)/llc
	llvm-strip $(DIR_LLVM)/lld
.PHONY: copy-strip

# 编译 (1) (非交叉)
b1-linux:
	mkdir -p $(DIR_BUILD)

	cd $(DIR_BUILD) && \
	env CC=clang CXX=clang++ \
	cmake $(G) $(A) \
		-DLLVM_USE_LINKER=lld -DLLVM_ENABLE_LTO=Full

	cd $(DIR_BUILD) && cmake $(CMAKE_BUILD)
.PHONY: b1-linux

# 编译 (2) 交叉
b2-cross:
	mkdir -p $(DIR_BUILD)

	cd $(DIR_BUILD) && \
	cmake --toolchain ../../cross/$(CROSS) $(G) $(A)

	cd $(DIR_BUILD) && cmake $(CMAKE_BUILD)
.PHONY: b2-cross

# 编译 (3) Android
b3-android:
	mkdir -p $(DIR_BUILD)

	cd $(DIR_BUILD) && \
	cmake --toolchain ../../cross/$(CROSS) $(G) $(A)

	cd $(DIR_BUILD) && cmake $(CMAKE_BUILD)
.PHONY: b3-android

# 编译 (4) emscripten
b4-wasm:
	mkdir -p $(DIR_BUILD)

	cd $(DIR_BUILD) && \
	emcmake cmake $(G) $(A) \
		-DLLVM_USE_LINKER=lld -DLLVM_ENABLE_LTO=Full

	cd $(DIR_BUILD) && cmake $(CMAKE_BUILD)
.PHONY: b4-wasm

# build LLVM: linux-x64
build-linux-x64: DIR_BUILD := build/linux-x64
build-linux-x64: DIR_LLVM := llvm-linux-x64-glibc
build-linux-x64: b1-linux copy-strip
.PHONY: build-linux-x64

# build LLVM: linux-arm64
build-linux-arm64: DIR_BUILD := build/linux-arm64
build-linux-arm64: DIR_LLVM := llvm-linux-arm64-glibc
build-linux-arm64: b1-linux copy-strip
.PHONY: build-linux-arm64

# build LLVM: linux-arm64 (cross)
build-linux-arm64-cross: DIR_BUILD := build/linux-arm64
build-linux-arm64-cross: DIR_LLVM := llvm-linux-arm64-glibc
build-linux-arm64-cross: CROSS := linux-arm64-glibc.cmake
build-linux-arm64-cross: b2-cross copy-strip
.PHONY: build-linux-arm64-cross

# build LLVM: linux-riscv64 (cross)
build-linux-riscv64-cross: DIR_BUILD := build/linux-riscv64
build-linux-riscv64-cross: DIR_LLVM := llvm-linux-riscv64-glibc
build-linux-riscv64-cross: CROSS := linux-riscv64-glibc.cmake
build-linux-riscv64-cross: b2-cross copy-strip
.PHONY: build-linux-riscv64-cross

# build LLVM: android-arm64
build-android-arm64: DIR_BUILD := build/android-arm64
build-android-arm64: DIR_LLVM := llvm-android-arm64
build-android-arm64: CROSS := android-arm64.cmake
build-android-arm64: b3-android copy-strip
.PHONY: build-android-arm64

# build LLVM: wasm (emscripten)
build-wasm: DIR_BUILD := build/wasm
build-wasm: DIR_LLVM := llvm-wasm
build-wasm: b4-wasm
	cp -r $(DIR_BUILD)/bin $(DIR_LLVM)
.PHONY: build-wasm

# build LLVM: win32-x64
build-win32-x64: DIR_BUILD := build/win32-x64
build-win32-x64: DIR_LLVM := llvm-win32-x64
build-win32-x64:
	mkdir -p $(DIR_BUILD)

	cd $(DIR_BUILD) && cmake $(G) $(A)

	cd $(DIR_BUILD) && cmake $(CMAKE_BUILD)

	cp -r $(DIR_BUILD)/bin $(DIR_LLVM)
.PHONY: build-win32-x64
