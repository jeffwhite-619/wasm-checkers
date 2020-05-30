(module
    (memory $mem 1)
    (global $currentTurn (mut i32) (i32.const 0))

    ;; checkerboard state bit flags:
    ;; 0 = Empty square
    ;; 1 = Black piece
    ;; 2 = Red piece
    ;; 4 = Crowned piece
    (global $RED i32 (i32.const 2))
    (global $BLACK i32 (i32.const 1))
    (global $CROWN i32 (i32.const 4))

    ;; map the checkboard into memory
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
    ;; x and y represent coordinates (index, offset) in the array
    ;; 8 is the number of checkboard squares in a row
    ;; 4 is the byte length of a 32-bit integer
    (func $offsetForPosition (param $x i32) (param $y i32) (result i32)
        (i32.mul
            (call $indexForPosition (local.get $x) (local.get $y))
            (i32.const 4)
        )
    )

    ;; check if piece is crowned
    (func $isCrowned (param $piece i32) (result i32)
        (i32.eq
            (i32.and (local.get $piece) (global.get $CROWN))
            (global.get $CROWN)
        )
    )

    ;; check if piece has bit flag for red color
    (func $isRed (param $piece i32) (result i32)
        (i32.eq
            (i32.and (local.get $piece) (global.get $RED))
            (global.get $RED)
        )
    )

    ;; check if piece has bit flag for black color
    (func $isBlack (param $piece i32) (result i32)
        (i32.eq
            (i32.and (local.get $piece) (global.get $BLACK))
            (global.get $BLACK)
        )
    )

    ;; set the bit flag for crowning a piece
    (func $kingMe (param $piece i32) (result i32)
        (i32.or (local.get $piece) (global.get $CROWN))
    )

    ;; unset the bit flag for a crowned piece
    (func $dethrone (param $piece i32) (result i32)
        (i32.and (local.get $piece) (i32.const 3))
    )

    ;; place a piece on a square
    (func $setPiece (param $x i32) (param $y i32) (param $piece i32)
        (i32.store 
            (call $offsetForPosition
                (local.get $x)
                (local.get $y)
            )
            (local.get $piece)
        )
    )

    ;; check state of a square, catch out of bounds errors
    (func $getPiece (param $x i32) (param $y i32) (result i32)
        (if (result i32)
            (block (result i32)
                (i32.and
                    (call $inRange
                        (i32.const 0)
                        (i32.const 7)
                        (local.get $x)
                    )
                    (call $inRange
                        (i32.const 0)
                        (i32.const 7)
                        (local.get $y)
                    )
                )
            )
        )
        (then
            (i32.load
                (call $offsetForPosition
                    (local.get $x)
                    (local.get $y)
                )
            )
        )
        (else
            (unreachable)
        )
    )

    ;; check row/square boundary
    (func $inRange (param $low i32) (param $high i32) (param $value i32) (result i32)
        (i32.and
            (i32.ge_s (local.get $value) (local.get $low))
            (i32.le_s (local.get $value) (local.get $high))
        )
    )

    ;; get the current turn owner
    (func $getTurnOwner (result i32)
        (global.get $currentTurn)
    )

    ;; change current turn owner
    (func $toggleTurnOwner
        (if (i32.eq (call $setTurnOwner) (i32.const 1))
            (then (call $setTurnOwner (i32.const 2)))
            (else (call $setTurnOwner (i32.const 1)))
        )
    )

    ;; set the current turn owner
    (func $setTurnOwner (param $piece i32)
        (global.set $currentTurn (local.get $piece))
    )

    ;; check who the current turn owner is
    (func $isPlayersTurn (param $player i32) (result i32)
        (i32.ge_s
            (i32.and (local.get $player) (call $getTurnOwner))
            (i32.const 0)
        )
    )
)