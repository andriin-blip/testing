' PLANE.BAS - a simple plane flying across the screen with engine sound
' Made for QB64 (free, Windows/Mac/Linux): open it and press F5.
' Starts full screen - press Alt+Enter for a window, then drag its edges
' to make it bigger or smaller. Press any key to quit.

'$RESIZE:STRETCH

DECLARE SUB DrawPlane (x!, y!, f!)
DECLARE SUB DrawCloud (cx!, cy!)
DECLARE SUB FillCircle (cx!, cy!, r!, c!)

CONST S = 2             ' plane size: 1 = small, 2 = big, 3 = huge

SCREEN 7, , 1, 0        ' 320x200, 16 colors; draw on page 1, show page 0
_FULLSCREEN _SQUAREPIXELS
RANDOMIZE TIMER

x = -60 * S             ' plane starts off the left edge
y = 80
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
    py = y + INT(SIN(frame / 6) * 2 * S)
    DrawPlane x, py, frame

    PCOPY 1, 0                             ' show the finished frame (no flicker)

    ' --- engine sound ---
    ' Pitch drops as the plane passes the middle (a simple Doppler effect),
    ' and alternates slightly each frame for a "putt-putt" engine.
    ' SOUND also works as the frame delay (1 tick = about 1/18 second).
    freq = 100 + (160 - (x + 24 * S)) / 8 + (frame MOD 2) * 20
    IF freq < 40 THEN freq = 40
    SOUND freq, 1

    ' --- move ---
    x = x + 2 + S
    IF x > 330 THEN
        x = -60 * S
        y = 15 * S + INT(RND * (130 - 25 * S))   ' new random height each pass
    END IF
    frame = frame + 1
LOOP UNTIL INKEY$ <> ""

SYSTEM

SUB DrawCloud (cx, cy)
    FillCircle cx, cy, 10, 15
    FillCircle cx + 12, cy - 5, 12, 15
    FillCircle cx + 26, cy, 10, 15
END SUB

SUB DrawPlane (x, y, f)
    ' The plane faces right: tail at x, nose at x + 48 * S.

    ' smoke puffs behind the tail
    FOR k = 1 TO 3
        FillCircle x - k * 8 * S, y + (k MOD 2) * S, k * S, 7
    NEXT k

    ' tail fin (red triangle)
    FOR i = 0 TO 10 * S - 1
        LINE (x + i, y - 3 * S)-(x + i, y - 12 * S + i), 4
    NEXT i

    LINE (x, y - 3 * S)-(x + 44 * S, y + 3 * S), 15, BF             ' body (white)
    LINE (x + 2 * S, y)-(x + 42 * S, y + S - 1), 4, BF              ' red stripe
    LINE (x + 44 * S, y - 3 * S)-(x + 48 * S, y + 3 * S), 4, BF     ' nose (red)
    LINE (x + 28 * S, y - 7 * S)-(x + 38 * S, y - 3 * S), 11, BF    ' cockpit window
    LINE (x + 14 * S, y + S)-(x + 32 * S, y + 4 * S), 1, BF         ' wing (dark blue)
    LINE (x, y + S)-(x + 8 * S, y + 3 * S), 1, BF                   ' tail wing

    ' spinning propeller: long blade and short blade on alternate frames
    px = x + 49 * S
    IF f MOD 2 = 0 THEN
        LINE (px, y - 9 * S)-(px + S - 1, y + 9 * S), 0, BF
    ELSE
        LINE (px, y - 2 * S)-(px + S - 1, y + 2 * S), 0, BF
    END IF
END SUB

SUB FillCircle (cx, cy, r, c)
    ' Filled circle made of horizontal lines (safe when partly off-screen).
    FOR dy = -r TO r
        dx = INT(SQR(r * r - dy * dy))
        LINE (cx - dx, cy + dy)-(cx + dx, cy + dy), c
    NEXT dy
END SUB
