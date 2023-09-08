Usage:
    build_ch chnum buildcmd

Args:
   chnum        chapter number (include leading 0)
   buildcmd     any valid argument supported by the msbuild /t switch

Examples:
   build_ch 02 build
   build_ch 02                  uses 'build' for buildcmd
   build_ch 02 clean
   build_ch 02 rebuild

Perform following steps to use build_ch:

1.  Open a "Developer Command Prompt for VS 2022" window.
    (located in the Start Menu under Visual Studio 2022)

2.  Navigate to the folder SourceCode\Scripts\win

3.  use build_ch as described above.

Use run_all.bat to execute all source code examples.
Use run_chxx.bat to execute the source code examples for chapter xx.
