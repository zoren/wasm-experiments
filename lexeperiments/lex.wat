(module
  (func $get_char (import "imports" "get_char") (result i32))
  (func $put_char (import "imports" "put_char") (param i32))
  (func $classify_char (param $c i32) (result i32)
    (block
    (block
    (block
    (block
    (block
    (block
    (br_table
      ;; 0 are control and illegal chars
      ;; 1 are digits, underscore and -
      ;; 2 are chars and dollar sign
      ;; 3 are whitespace
      ;; 4 are atomic chars (, ) and .
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;; NUL SOH STX ETX EOT ENQ ACK BEL BS HT LF VT FF CT SO SI
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;; control characters
      3 0 4 0 2 0 0 0 4 4 0 0 0 1 4 0 ;; space ! " # $ % & ' ( ) * + - . /
      1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 ;; 0123456789:;<=>?
      0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 ;; @ABC...O
      2 2 2 2 2 2 2 2 2 2 2 0 0 0 0 1 ;; PQR...Z[\]^_
      0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 ;; `abc...o
      2 2 2 2 2 2 2 2 2 2 2 0 0 0 0 0 ;; pqr...z{|}~ DEL
      0                               ;; above ASCII
      (local.get $c)
    )
    )
    (return (i32.const 0)))
    (return (i32.const 1)))
    (return (i32.const 2)))
    (return (i32.const 3)))
    (return (i32.const 4)))
    (i32.const 9)
  )
  (memory (export "mem") 1)
  (func $printBuffer (param $length i32) (local $index i32)
    (block
    (loop
      (br_if 1 (i32.eq (i32.add (local.get $length) (i32.const 1)) (local.get $index)))
      (call $put_char (i32.load8_u (local.get $index)))
      (local.set $index (i32.add (local.get $index) (i32.const 1)))
      br 0
    )
    )
    (call $put_char (i32.const 10))
  )
  (global $freeMemAddress (mut i32) (i32.const 0))
  (func $abort (param $c i32)
    (call $put_char (i32.const 69))
    (call $put_char (i32.const 32))
    (call $put_char (local.get $c))
    (call $put_char (i32.const 10))
    unreachable
  )
  (func $alloc (param $length i32) (result i32) (local $curFree i32)
    (local.set $curFree (global.get $freeMemAddress))
    (global.set $freeMemAddress (i32.add (global.get $freeMemAddress) (local.get $length)))
    (if (i32.gt_u (global.get $freeMemAddress) (i32.mul (i32.const 65536) (memory.size)))
      (then
        ;; todo grow memory
        (call $abort (i32.const 77))))
    (return (local.get $curFree))
  )
  (func (export "main") (local $c i32)
    (local $curCharClass i32)
    (local $prevCharClass i32)
    (local $firstCharClass i32)
    (local $bufferIndex i32)
    (local $buffer i32)

    (local.set $prevCharClass (i32.const -1))
    (local.set $buffer (call $alloc (i32.const 8)))
    (local.set $bufferIndex (local.get $buffer))
    (loop
        (local.set $c (call $get_char))
        ;; stop at EOF
        (if (i32.lt_s (local.get $c) (i32.const 0))
          (then
            (call $printBuffer (local.get $bufferIndex))
            br 2
          )
        )
        (local.set $curCharClass (call $classify_char (local.get $c)))
        ;; abort on illegal char
        (if (i32.eq (local.get $curCharClass) (i32.const 0))
          (then (call $abort (i32.const 73)))
        )
        ;; numbers 0 -1 128 1_000
        ;; names i32 eq get $abort
        ;; whitespace ' ', \t, \n
        ;; atomic chars
        ;; quoted strings, " followed by any number of non-" ended by "
        (if
          (i32.or
            (i32.and (i32.ne (local.get $curCharClass) (i32.const 4))
              (i32.eq (local.get $prevCharClass) (local.get $curCharClass)))
            (i32.and (i32.eq (local.get $firstCharClass) (i32.const 2))
                      (i32.eq (local.get $curCharClass) (i32.const 1))
            )
          )
          (then
            (block
              (if (i32.eq (i32.add (local.get $buffer) (i32.const 7)) (local.get $bufferIndex))
                (then (call $abort (i32.const 66)))
              )
              (local.set $bufferIndex (i32.add (local.get $bufferIndex) (i32.const 1)))
            )
          )
          (else
            (block
              (call $printBuffer (local.get $bufferIndex))
              (local.set $firstCharClass (local.get $curCharClass))
              (local.set $bufferIndex (local.get $buffer))
            )
          )
        )
        (i32.store8 (local.get $bufferIndex) (local.get $c))
        (local.set $prevCharClass (local.get $curCharClass))
        br 0
    )
  )
)
