#! /usr/bin/osascript
property text item delimiters: " -- "

on alfred_script(input)

  set {flags, command} to {text item 1, last text item} of input

  tell app "Finder" to ¬
  set PFD to posix path of (target of window 1 as alias)
  set SHELL to system attribute "SHELL"

  if flags is "-il"
    tell app "Terminal"
      if running
        activate
        delay .4
        tell app "System Events" to keystroke "t" using command down

        do script "cd '" & PFD & "'; clear;" & command in window 1
        return
      end if
    end tell

    do shell script "open --fresh -b com.apple.terminal '" & PFD & "'"
    delay .1
    tell app "Terminal" to do script command in window 1
    return

  else if flags is not "-i"
    set flags to "-"
  end if

  try
    do shell script ¬
    "cd '" & PFD & "';" & SHELL & space & flags & "c '" & command & "'"
  on error stderr
    return stderr
  end try

end alfred_script