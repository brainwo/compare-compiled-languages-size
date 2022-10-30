@default:
	just clean
	just gcc-c
	just clang-c
	just zigcc-c
	just rustc-rust
	just gdc-d
	just ldc-d
	just dmd-d
	just odin-odin
	just nelua-nelua
	just go-go
	just tinygo-go
	just jakt1-jakt
	just jakt2-jakt
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
	strip -s bin/*
	exa -l --sort size --no-user --no-time --no-permissions --no-icons bin
	just get-size
	just version
	python3 scripts/bar_chart.py
	python3 scripts/generate_readme.py

bench:
	zsh -c time ./bin/gcc-c
	zsh -c time ./bin/clang-c
	zsh -c time ./bin/zigcc-c
	zsh -c time ./bin/rustc-rust
	zsh -c time ./bin/ldc-d
	zsh -c time ./bin/odin-odin
	zsh -c time ./bin/nelua-nelua
	zsh -c time ./bin/go-go
	zsh -c time ./bin/tinygo-go
	zsh -c time ./bin/jakt1-jakt
	zsh -c time ./bin/jakt2-jakt
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

@version:
	echo -n "gcc|" > version.txt
	gcc --version | head -1 >> version.txt
	echo -n "clang|" >> version.txt
	clang --version | head -1 >> version.txt
	echo -n "zigcc|" >> version.txt
	zig cc --version | head -1 >> version.txt
	echo -n "rustc|" >> version.txt
	rustc --version >> version.txt
	echo -n "gdc|" >> version.txt
	gdc --version | head -1 >> version.txt
	echo -n "dmd|" >> version.txt
	dmd --version | head -1 >> version.txt
	echo -n "ldc|" >> version.txt
	ldc --version | head -1 >> version.txt
	echo -n "odin|" >> version.txt
	odin version | head -1 >> version.txt
	echo -n "nelua|" >> version.txt
	nelua --version | head -1 >> version.txt
	echo -n "go|" >> version.txt
	go version >> version.txt
	echo -n "tinygo|" >> version.txt
	tinygo version >> version.txt
	echo -n "valac|" >> version.txt
	valac --version >> version.txt
	echo -n "crystal|" >> version.txt
	crystal --version | grep "Crystal" --color=never >> version.txt
	echo -n "v|" >> version.txt
	v --version >> version.txt
	echo -n "nim|" >> version.txt
	nim --version | head -1 >> version.txt
	echo -n "dart|" >> version.txt
	dart --version >> version.txt
	echo -n "kotlinc|" >> version.txt
	kotlinc-native -version >> version.txt
	echo -n "gnatmake|" >> version.txt
	gnatmake --version | head -1 >> version.txt
	echo -n "ghc|" >> version.txt
	ghc --version >> version.txt
	echo -n "swiftc|" >> version.txt
	swiftc --version | head -1 >> version.txt
	echo -n "zig|" >> version.txt
	zig version >> version.txt
	echo -n "koka|" >> version.txt
	koka --version | head -1 | cut -c 5- >> version.txt
	echo -n "nasm|" >> version.txt
	nasm -v >> version.txt
	echo -n "ocamlopt|" >> version.txt
	ocamlopt --version >> version.txt

@get-size:
	exa --sort size --long -B --no-user --no-icons --no-permissions --no-time bin > size.txt

@gcc-c:
	gcc lang/c/main.c -s -o bin/gcc-c

@clang-c:
	clang lang/c/main.c -s -o bin/clang-c

@zigcc-c:
	zig cc lang/c/main.c -s -o bin/zigcc-c

@rustc-rust:
	rustc -C opt-level=z -C lto=yes -C strip=debuginfo -C debuginfo=0 -C panic=abort -C codegen-units=1 -C incremental=false -o bin/rustc-rust lang/rust/main.rs

@gdc-d:
	gdc lang/d/main.d -s -o bin/gdc-d

@ldc-d:
	ldc lang/d/main.d -Oz --of=bin/ldc-d --release
	rm bin/ldc-d.o

@dmd-d:
	dmd lang/d/main.d -O -of=bin/dmd-d -release
	rm bin/dmd-d.o

@odin-odin:
	odin build lang/odin/main.odin -file -out:bin/odin-odin -o:size -disable-assert

@nelua-nelua:
	nelua lang/nelua/main.nelua -b -s -r --output bin/nelua-nelua

@go-go:
	go build -ldflags '-s -w' -o bin/go-go lang/go/main.go

@jakt1-jakt:
	mkdir -p build
	jakt_stage1 -O -o jakt1-jakt lang/jakt/main.jakt
	mv build/jakt1-jakt bin/jakt1-jakt
	rm -r build

@jakt2-jakt:
	mkdir -p build
	jakt_stage2 -O -o jakt2-jakt lang/jakt/main.jakt
	mv build/jakt2-jakt bin/jakt2-jakt
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
	zig build-exe -O ReleaseSmall -fstrip lang/zig/main.zig
	mv main bin/zig-zig
	rm main.o

@koka-koka:
	koka --compile lang/koka/main.kk -o bin/koka-koka -O=3

@ocamlopt-ocaml:
	ocamlopt -o bin/ocamlopt-ocaml -compact lang/ocaml/main.ml 
	rm lang/ocaml/main.cmi lang/ocaml/main.cmx lang/ocaml/main.o

@clean:
	rm -rf bin
	mkdir bin
