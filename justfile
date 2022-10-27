@default:
	just gcc-c
	just clang-c
	just rustc-rust
	just ldc-d
	just odin-odin
	just nelua-nelua
	just go-go
	just tinygo-go
	just jakt-jakt
	just valac-vala
	just crystal-crystal
	just v-v
	just nim-nim
	just dart-dart
	just kotlinc-kotlin
	just gnatmake-ada
	just ghc-haskell
	just swiftc-swift
	just nasm-asm
	just zig-zig
	just koka-koka
	just ocamlopt-ocaml
	exa -l --sort size --no-user --no-time --no-permissions --no-icons bin

bench:
	zsh -c time ./bin/gcc-c
	zsh -c time ./bin/clang-c
	zsh -c time ./bin/rustc-rust
	zsh -c time ./bin/ldc-d
	zsh -c time ./bin/odin-odin
	zsh -c time ./bin/nelua-nelua
	zsh -c time ./bin/go-go
	zsh -c time ./bin/tinygo-go
	zsh -c time ./bin/jakt-jakt
	zsh -c time ./bin/valac-vala
	zsh -c time ./bin/crystal-crystal
	zsh -c time ./bin/v-v
	zsh -c time ./bin/nim-nim
	zsh -c time ./bin/dart-dart
	zsh -c time ./bin/kotlinc-kotlin
	zsh -c time ./bin/gnatmake-ada
	zsh -c time ./bin/ghc-haskell
	zsh -c time ./bin/swiftc-swift
	zsh -c time ./bin/zig-zig
	zsh -c time ./bin/koka-koka
	zsh -c time ./bin/nasm-asm
	zsh -c time ./bin/ocamlopt-ocaml

@get-size:
	exa --sort size --long -B --no-user --no-icons --no-permissions --no-time bin > size.txt

@gcc-c:
	gcc lang/c/main.c -s -o bin/gcc-c

@clang-c:
	clang lang/c/main.c -s -o bin/clang-c

@rustc-rust:
	rustc -C opt-level=z -C lto=yes -C strip=debuginfo -C debuginfo=0 -C panic=abort -C codegen-units=1 -C incremental=false -o bin/rustc-rust lang/rust/main.rs

@ldc-d:
	ldc lang/d/main.d --of=bin/ldc-d --release
	rm bin/ldc-d.o

@odin-odin:
	odin build lang/odin/main.odin -file -out:bin/odin-odin -o:size -disable-assert

@nelua-nelua:
	nelua lang/nelua/main.nelua -b -s -r --output bin/nelua-nelua

@go-go:
	go build -ldflags '-s -w' -o bin/go-go lang/go/main.go

@jakt-jakt:
	mkdir build
	jakt -O -R /usr/lib/jakt -o jakt-jakt lang/jakt/main.jakt
	mv build/jakt-jakt bin/jakt-jakt
	rm -r build

@valac-vala:
	valac -c -o bin/valac-vala lang/vala/main.vala

@crystal-crystal:
	crystal build --release --threads 1 -o bin/crystal-crystal lang/crystal/main.cr

@v-v:
	v lang/v/main.v -o bin/v-v -prod

@tinygo-go:
	tinygo build -o bin/tinygo-go lang/go/main.go

@nasm-asm:
	nasm -f elf64 -o bin/nasm-asm.o lang/asm/main.asm
	ld -o bin/nasm-asm bin/nasm-asm.o
	rm bin/nasm-asm.o

@fasm-asm:
	fasm lang/asm/main.asm bin/fasm-asm.
	ld -o bin/fasm-asm bin/fasm-asm.o
	rm bin/fasm-asm.o

@nim-nim:
	nim compile --opt:size -a:off -x:off --lineTrace:off --stackTrace:off --threads:off --debuginfo:off -d:strip --gc:arc --passL:-flto -d:useMalloc -o:bin/nim-nim lang/nim/main.nim

@dart-dart:
	dart compile exe lang/dart/main.dart -o bin/dart-dart
  
@kotlinc-kotlin:
	kotlinc-native lang/kotlin/main.kt -o bin/kotlinc-kotlin -opt
	mv bin/kotlinc-kotlin.kexe bin/kotlinc-kotlin

@gnatmake-ada:
	gnatmake lang/ada/main.ada
	mv main bin/gnatmake-ada
	rm main.ali main.o

@ghc-haskell:
	ghc lang/haskell/main.hs -O
	mv lang/haskell/main bin/ghc-haskell
	rm lang/haskell/main.hi lang/haskell/main.o

@swiftc-swift:
	swiftc lang/swift/main.swift -o bin/swiftc-swift -O -static -suppress-warnings -assert-config Release -Osize -Onone -Ounchecked

@zig-zig:
	zig build-exe -O ReleaseSmall --strip lang/zig/main.zig
	mv main bin/zig-zig
	rm main.o

@koka-koka:
	koka --compile lang/koka/main.kk -o bin/koka-koka -O=3

@ocamlopt-ocaml:
	ocamlopt -o bin/ocamlc-ocaml -compact lang/ocaml/main.ml 
	rm lang/ocaml/main.cmi lang/ocaml/main.cmx lang/ocaml/main.o
