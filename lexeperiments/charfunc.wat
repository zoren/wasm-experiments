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
