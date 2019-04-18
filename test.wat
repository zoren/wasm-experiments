(module
;;   (func $i (import "imports" "imported_func") (param i32))
;;   (func (export "exported_func")
;;     i32.const 42
;;     call $i
;;   )
  (func (export "fac") (param $x i32) (result i32)
    (if (result i32) (i32.eq (get_local $x) (i32.const 0))
        (then (i32.const 1))
        (else
        (i32.mul (get_local $x) (call 0 (i32.sub (get_local $x) (i32.const 1))))
        )
    )
  )
)