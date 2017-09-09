
Dim oShell
Dim oAutoIt
Set oShell = WScript.CreateObject("WScript.Shell")
Set oAutoIt = WScript.CreateObject("AutoItX3.Control")
'WScript.Echo "This script will reset your google password 100 times so you can use an old password."


sUN = "lovnitekameri@gmail.com"
curPW = "valkata1010"
oldPW = "valkata1"
iSlowConnectionFactor = 1

ChromeEXE = "chrome.exe"

oShell.Run ChromeEXE, 1, False
oAutoIt.Sleep 2000
' WScript.Echo "Entering Loop"
' Enter the loop, change the password 99 more times
tCurPw = curPW
For x = 1 To 99
'    WScript.Echo "Step " & x
'    WScript.Echo "Current PW: " & tCurPw
    tNewPW = curPW & x
    'WScript.Echo "Setting the password to: " & tNewPW            ' output the password in case it crashes the user can see what it is.

    GLogin sUN, tCurPw                            ' log into google with current password
    GEditPW                                ' load the edit password page, old password should have focus after it loads.
    oAutoIt.Send tCurPw & "{ENTER}"                    ' enter the old (last) password and tab TWICE (once out of field, and once past password reset link)
    oAutoIt.Sleep 2250 * iSlowConnectionFactor                 ' waits x ms times slow connection
    oAutoIt.Send tNewPW & "{TAB}{TAB}{TAB}"                    ' type new password
    oAutoIt.Sleep 1250 * iSlowConnectionFactor                 ' waits x ms times slow connection
    oAutoIt.Send tNewPW & "{TAB}{TAB}"                    ' types the new password again then tab (should highlight "change password button")
    oAutoIt.Sleep 1250 * iSlowConnectionFactor                 ' waits x ms times slow connection
    oAutoIt.Send "{ENTER}"                        ' Hit enter to submit the password reset.
    oAutoIt.Sleep 3000 * iSlowConnectionFactor                 ' waits x ms times slow connection

    tCurPw = tNewPW                            ' updates the current password.
    GLogout                                ' logs out of google – it has to do this for password change to stick.
                                    ' At this point, the process should repeat.
Next
WScript.Echo "Final Change"                        ' Last time
GLogin sUN, tCurPw                            ' log into google with current password.
GEditPW                                    ' load the edit password page
oAutoIt.Send tCurPw & "{TAB}{TAB}"                    ' enter the old (last) password and tab TWICE (once out of field, and once past password reset link)
oAutoIt.Sleep 250 * iSlowConnectionFactor                 ' waits x ms times slow connection
oAutoIt.Send oldPW & "{TAB}{TAB}"                        ' enter the password, used password and hit tab
oAutoIt.Sleep 250 * iSlowConnectionFactor                ' waits x ms times slow connection
oAutoIt.Send oldPW & "{TAB}"                        ' enter the password, used password and hit tab
oAutoIt.Sleep 250 * iSlowConnectionFactor                 ' waits x ms times slow connection
oAutoIt.Send "{ENTER}"                            ' Submit the password reset
oAutoIt.Send "https://www.google.com/accounts/Logout{ENTER}"        ' Log out to make the password stick
oAutoIt.Sleep 2000 * iSlowConnectionFactor                 ' waits x ms times slow connection
WScript.Echo "Password reset"
WScript.Quit
' Script complete.
Function GLogin(un, pw) ' Opens the Google Login page, enters the supplied Username (un) and Password (pw), and presses Enter.
    'WScript.Echo "Logging in: " & un & ", " & pw
    oAutoIt.Send "!d"                            ' This goes to the address bar
    oAutoIt.Sleep 250 * iSlowConnectionFactor                 ' waits x ms times slow connection
'    oAutoIt.Send "https://accounts.google.com/ServiceLogin?Email={ENTER}" ' types this url and hits enter. Upon load, email field should have focus. Email param makes it empty.
    oAutoIt.Send "https://accounts.google.com/ServiceLogin?Email={ENTER}"
    oAutoIt.Sleep 1000 * iSlowConnectionFactor                 ' waits x ms times slow connection
    oAutoIt.Send un & "{TAB}{TAB}{ENTER}"                        ' types username and hits tab
    oAutoIt.Sleep 1000 * iSlowConnectionFactor                 ' waits x ms times slow connection
    oAutoIt.Send pw & "{ENTER}"                        ' types password and hits enter
    oAutoIt.Sleep 4000 * iSlowConnectionFactor                 ' waits x ms times slow connection.
End Function
Function GEditPW() ' Opens the Google Change Password web page
    oAutoIt.Send "!d"                            ' go to address bar
    oAutoIt.Sleep 250 * iSlowConnectionFactor                 ' waits x ms times slow connection
    oAutoIt.Send "https://accounts.google.com/b/0/EditPasswd{ENTER}"    ' go the edit password page
    oAutoIt.Sleep 2000 * iSlowConnectionFactor                 ' waits x ms times slow connection
End Function
Function GLogout() ' Logs out from google. This is necessary for the password change to take effect. Trust me, I tried to do it without logging out. No luck.
   ' WScript.Echo "Logging out"
    oAutoIt.Send "!d"                            ' this goes to the address bar
    oAutoIt.Sleep 250 * iSlowConnectionFactor                 ' waits x ms times slow connection
    oAutoIt.Send "https://www.google.com/accounts/Logout{ENTER}"    ' This logs out of google.
    oAutoIt.Sleep 5000 * iSlowConnectionFactor                 ' waits x ms times slow connection
End Function

