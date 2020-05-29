(module
    (func $indexForPosition (param $x i32) (param $y i32) (result i32)
        (i32.add
            (i32.mul
                (i32.const 8)
                (local.get $y)
            )
            (local.get $x)
        )
    )
    ;; offset = (x + y * 8) * 4
    ;; checkerboard as two-dimensional array visualized in linear memory
    ;; x and y represent coordinates (index, offset) in the array, 8 is the number of checkboard squares in a row, 4 is the byte length of a 32-bit integer

    (func $offsetForPosition (param $x i32) (param $y i32) (result i32)
        (i32.mul
            (call $indexForPosition (local.get $x) (local.get $y))
            (i32.const 4)
        )
    )
)