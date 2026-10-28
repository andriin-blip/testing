' PLANE.BAS - a simple plane flying across the screen with engine sound
' Runs in QB64 (free, Windows/Mac/Linux) or QBasic 1.1 (DOS / DOSBox).
' Press any key to quit.

DECLARE SUB DrawPlane (x!, y!, f!)
DECLARE SUB DrawCloud (cx!, cy!)
DECLARE SUB FillCircle (cx!, cy!, r!, c!)

SCREEN 7, , 1, 0        ' 320x200, 16 colors; draw on page 1, show page 0
RANDOMIZE TIMER

x = -60                 ' plane starts off the left edge
y = 60
frame = 0

DO
    ' --- background ---
    LINE (0, 0)-(319, 159), 9, BF          ' sky
    LINE (0, 160)-(319, 199), 2, BF        ' grass
    FillCircle 280, 30, 14, 14             ' sun

    ' clouds drift slowly to the left
    cx = 340 - ((frame \ 2) MOD 400)
    DrawCloud cx, 35
    DrawCloud cx + 180, 70

    ' --- plane, with a gentle up/down bob ---
    py = y + INT(SIN(frame / 6) * 4)
    DrawPlane x, py, frame

    PCOPY 1, 0                             ' show the finished frame (no flicker)

    ' --- engine sound ---
    ' Pitch drops as the plane passes the middle (a simple Doppler effect),
    ' and alternates slightly each frame for a "putt-putt" engine.
    ' SOUND also works as the frame delay (1 tick = about 1/18 second).
    freq = 100 + (160 - x) / 8 + (frame MOD 2) * 20
    IF freq < 40 THEN freq = 40
    SOUND freq, 1

    ' --- move ---
    x = x + 3
    IF x > 340 THEN
        x = -60
        y = 30 + INT(RND * 80)             ' new random height each pass
    END IF
    frame = frame + 1
LOOP UNTIL INKEY$ <> ""

SCREEN 0: WIDTH 80
END

SUB DrawCloud (cx, cy)
    FillCircle cx, cy, 10, 15
    FillCircle cx + 12, cy - 5, 12, 15
    FillCircle cx + 26, cy, 10, 15
END SUB

SUB DrawPlane (x, y, f)
    ' The plane faces right: tail at x, nose at x + 48.

    ' smoke puffs behind the tail
    FOR k = 1 TO 3
        FillCircle x - k * 8, y + (k MOD 2), k, 7
    NEXT k

    ' tail fin (red triangle)
    FOR i = 0 TO 9
        LINE (x + i, y - 3)-(x + i, y - 12 + i), 4
    NEXT i

    LINE (x, y - 3)-(x + 44, y + 3), 15, BF        ' body (white)
    LINE (x + 2, y)-(x + 42, y), 4                 ' red stripe
    LINE (x + 44, y - 3)-(x + 48, y + 3), 4, BF    ' nose (red)
    LINE (x + 28, y - 7)-(x + 38, y - 3), 11, BF   ' cockpit window (light blue)
    LINE (x + 14, y + 1)-(x + 32, y + 4), 1, BF    ' wing (dark blue)
    LINE (x, y + 1)-(x + 8, y + 3), 1, BF          ' tail wing

    ' spinning propeller: long blade and short blade on alternate frames
    IF f MOD 2 = 0 THEN
        LINE (x + 49, y - 9)-(x + 49, y + 9), 0
    ELSE
        LINE (x + 49, y - 2)-(x + 49, y + 2), 0
    END IF
END SUB

SUB FillCircle (cx, cy, r, c)
    ' Filled circle made of horizontal lines (safe when partly off-screen).
    FOR dy = -r TO r
        dx = INT(SQR(r * r - dy * dy))
        LINE (cx - dx, cy + dy)-(cx + dx, cy + dy), c
    NEXT dy
END SUB
