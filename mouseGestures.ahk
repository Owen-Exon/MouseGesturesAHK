#Requires AutoHotkey v2.0
#SingleInstance Force

pi := 4 * atan(1)

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

angle(p) {
    Return (DllCall('msvcrt.dll\atan2', 'Double', p[2], 'Double', p[1], 'Cdecl Double')/pi)*-180
}


findMotion(movement)  {
    movementAngle := angle(movement)
    if -22.5 < movementAngle and movementAngle < 22.5 {
        return "R"
    } else If 22.5 < movementAngle and movementAngle < 67.5 {
        return "1"
    } else If 67.5 < movementAngle and movementAngle < 112.5 {
        return "U"
    } else If 112.5 < movementAngle and movementAngle < 157.5{
        return "2"
    } else If (157.5 < movementAngle and movementAngle < 180) OR (-180 < movementAngle and movementAngle < -157.5) {
        return "L"
    } else If -157.5 < movementAngle and movementAngle < -112.5 {
        return "3"
    } else If -112.5 < movementAngle and movementAngle < -67.5 {
        return "D"
    } else If -67.5 < movementAngle and movementAngle < -22.5 {
        return "4"
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