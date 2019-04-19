(module
  (func $get_char (import "imports" "get_char") (result i32))
  (func $put_char (import "imports" "put_char") (param i32))
  ;; check if x is in the inclusive range from lower to upper
  (func $is_between (param $lower i32) (param $upper i32) (param $x i32) (result i32)
    (select
      (i32.le_u (local.get $x) (local.get $upper))
      (i32.const 0)
      (i32.le_u (local.get $lower) (local.get $x))
    )
  )
  (func $is_digit (param i32) (result i32)
    i32.const 48 ;; 0
    i32.const 57 ;; 9
    local.get 0
    call $is_between
  )
  (func (export "main") (local $c i32)
    (loop
        call $get_char
        local.set $c
        (br_if 1 (i32.lt_s (local.get $c) (i32.const 0)))
        (select (i32.const 84) (i32.const 70) (call $is_digit (local.get $c)))
        call $put_char
        br 0
    )
  )
)
