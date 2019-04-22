(module
  (func $get_char (import "imports" "get_char") (result i32))
  (func $put_char (import "imports" "put_char") (param i32))
  ;; check if x is in the inclusive range from lower to upper
  (func $is_between (param $lower i32) (param $upper i32) (param $x i32) (result i32)
    (if (result i32) (i32.le_u (local.get $lower) (local.get $x))
      (then (i32.le_u (local.get $x) (local.get $upper)))
      (else (i32.const 0))
    )
  )
  (func $is_digit (param i32) (result i32)
    i32.const 48 ;; 0
    i32.const 57 ;; 9
    local.get 0
    call $is_between
  )
  (func $is_upper (param i32) (result i32)
    i32.const 65  ;; A
    i32.const 90 ;; Z
    local.get 0
    call $is_between
  )
  (func $is_lower (param i32) (result i32)
    i32.const 97  ;; a
    i32.const 122 ;; z
    local.get 0
    call $is_between
  )
  (func $is_alpha (param i32) (result i32)
    (select
      (i32.const 1)
      (call $is_lower (local.get 0))
      (call $is_upper (local.get 0))
    )
  )
  (func $classify_char (param $c i32) (result i32)
    (block
    (block
    (block
    (block
    (block
    (br_table
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;; NUL SOH STX ETX EOT ENQ ACK BEL BS HT LF VT FF CT SO SI
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;; control characters
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;; space ! " # $ & ' ( ) * + - . /
      1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 ;; 0123456789:;<=>?
      0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 ;; @ABC...O
      2 2 2 2 2 2 2 2 2 2 2 0 0 0 0 0 ;; PQR...Z[\]^_
      0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 ;; `abc...o
      3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 ;; pqr...z{|}~ DEL
      4
      (local.get $c)
    )
    )
    (return (i32.const 0)))
    (return (i32.const 1)))
    (return (i32.const 2)))
    (return (i32.const 3)))
    (i32.const 9)
  )
  (func (export "main") (local $c i32)
    (loop
        call $get_char
        local.set $c
        (br_if 1 (i32.lt_s (local.get $c) (i32.const 0)))
        (i32.add (i32.const 48) (call $classify_char (local.get $c)))
        call $put_char
        br 0
    )
  )
)
