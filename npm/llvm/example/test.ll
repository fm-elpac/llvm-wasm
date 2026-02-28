; test.ll

; global readonly data
@.str1 = private unnamed_addr constant [8 x i8] c"test 666", align 1

; extern API
; output i32
declare void @print_i32(i32) nounwind #1

; output utf8 str (offset, len)
declare void @print_utf8(ptr, i32) nounwind #2

; export function
define void @main() nounwind #0 {
  call void @print_i32(i32 233)

  call void @print_utf8(ptr @.str1, i32 8)

  ret void
}

; wasm export name
attributes #0 = { "wasm-export-name"="main" }

; wasm import name
attributes #1 = { "wasm-import-module"="t1" "wasm-import-name"="print_i32" }
attributes #2 = { "wasm-import-module"="t1" "wasm-import-name"="print_utf8" }
