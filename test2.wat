(module
  (type $t0 (func (param i32) (result i32)))
  (func $fac (type $t0) (param $x i32) (result i32)
    get_local $x
    i32.eqz
    if $I0 (result i32)
      i32.const 1
    else
      get_local $x
      get_local $x
      i32.const 1
      i32.sub
      call $fac
      i32.mul
    end)
  (export "fac" (func $fac)))
