(module
  (func $get_char (import "imports" "get_char") (result i32))
  (func $put_char (import "imports" "put_char") (param i32))
  (func (export "main") (local i32)
    (loop
        call $get_char
        local.tee 0
        i32.const 1
        i32.add
        call $put_char
        local.get 0
        (br_if 1 (i32.lt_s (local.get 0) (i32.const 0)))
        (br 0)
    )
  )
)
