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



findMotion(movement)  {
    x := movement[1]
    y := movement[2]
    if (Abs(y) <= 100) {
        if isPositive(x) {
            return "R"
        } else {
            return "L"
        }
    } else If (Abs(x) <= 100) {
        if isPositive(-y) { ; Up is -ve coords for some reason
            return "U"
        } else {
            return "D"
        }
    } else if (Abs(Abs(x) - Abs(y)) <= 200){
        if isPositive(x) {
            if isPositive(-y) {
                return "1"
            } else {
                return "2"
            }
        } else {
            if isPositive(-y) {
                return "4"
            } else {
                return "3"
            }
        }
    } else {
        return "?"
    }

}

global keyLButton := false
LButton:: {
    global keyLButton := true
    KeyWait("LButton")
}
Hotkey("LButton","Off")

CapsLock::{
    KeyWait("CapsLock")
    global keyLButton
    positions := []
    
    SetCapsLockState("AlwaysOff")
    Hotkey("CapsLock","Off")
    Hotkey("LButton","On") ; Allow hotkey to change keyLButton variable
    
    while !GetKeyState("CapsLock","P") { ; Until CapsLock is pressed again
        if keyLButton { 
            MouseGetPos(&x,&y)
            positions.Push([x,y])
            keyLButton := false
        }
    }

    Hotkey("LButton","Off") ; Allow mouse to be used again

    if positions.Length > 1 { ; Skip if less than 2 clicks
        
        i := 1
        differences := []
        
        while i < positions.Length {
            differences.Push(difference(positions[i],positions[i+1]))
            i += 1
        }
        
        motions := ""
        for movement in differences {
            motions := motions findMotion(movement)
        }

        MsgBox(motions)
    }

    SetCapsLockState("Off")
    Hotkey("CapsLock","On")
}

Esc::{
    ExitApp()
}