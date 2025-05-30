#Requires AutoHotkey v2.0
#SingleInstance Force

WaitAndReturnInput(Keys:="{All}",Exept:="{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}") {
    ih := InputHook()
    ih.KeyOpt(Keys,"ES")
    ih.KeyOpt(Exept, "-ES")
    ih.Start()
    ih.Wait()
    return ih.EndMods . ih.EndKey
}

isPositive(x) {
    return (x = Abs(x))
}

difference(p1,p2) {
    return [p2[1]-p1[1],p2[2]-p1[2]]
}

distance(p1,p2) {
    dp := difference(p1,p2)
    dx := dp[1]
    dy := dp[2]
    return Sqrt(dx**2 + dy**2)
}

!c::{
    positions := []
    key := ""
    while !(key = "c") {
        key := WaitAndReturnInput("c{Space}")
        if (key = "Space") {
            MouseGetPos(&x,&y)
            positions.Push([x,y])
        }
    }
    i := 1
    differences := []
    while i < positions.Length {
        differences.Push(difference(positions[i],positions[i+1]))
        i += 1
    }
    motions := ""
    for movement in differences {
        x := movement[1]
        y := movement[2]
        if (Abs(y) <= 20) {
            if isPositive(x) {
                motions := motions "R"
            } else {
                motions := motions "L"
            }
        } else If (Abs(x) <= 20) {
            if isPositive(-y) { ; Up is -ve coords for some reason
                motions := motions "U"
            } else {
                motions := motions "D"
            }
        } else if (Abs(Abs(x) - Abs(y)) <= 50){
            if isPositive(x) {
                if isPositive(-y) {
                    motions := motions "1"
                } else {
                    motions := motions "2"
                }
            } else {
                if isPositive(-y) {
                    motions := motions "4"
                } else {
                    motions := motions "3"
                }
            }
        }
    }
    MsgBox(motions)
}

Esc::{
    ExitApp()
}