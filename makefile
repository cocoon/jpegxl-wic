
TITLE= jxlwic

BUILDDIR= $(MAKEDIR)
ROOTDIR= $(BUILDDIR)\..
SRCDIR= $(BUILDDIR)\src
INCDIR= $(BUILDDIR)\inc
BINDIR32= $(BUILDDIR)\bin\x86_32
BINDIR64= $(BUILDDIR)\bin\x86_64
LIBDIR32= $(BUILDDIR)\lib\x86_32
LIBDIR64= $(BUILDDIR)\lib\x86_64
UTILDIR= $(BUILDDIR)\util
RELEASEDIR= $(BUILDDIR)\release
RELEASEINCDIR= $(RELEASEDIR)\inc\$(TITLE)
RELEASELIBDIR32= $(RELEASEDIR)\lib\x86_32
RELEASEBINDIR32= $(RELEASEDIR)\bin\x86_32
RELEASELIBDIR64= $(RELEASEDIR)\lib\x86_64
RELEASEBINDIR64= $(RELEASEDIR)\bin\x86_64
TEMPDIR= $(BUILDDIR)\.build_win32
VERFILE= $(RELEASEDIR)\$(TITLE).version 

INCARG= /I$(SRCDIR) /I$(INCDIR)
SRCARG= $(SRCDIR)\*.cpp
LIBARG32=
LIBARG64= hwy.lib jxl-static.lib jxl.lib jxl_threads-static.lib jxl_threads.lib user32.lib ole32.lib shell32.lib windowscodecs.lib

CC= cl.exe
CFLAGS= $(INCARG) /std:c++14 /EHsc /MT /permissive- /W0 /Gm /Zi /O2 /Fo"$(TEMPDIR)/" /D"WIN32" /D"_CRT_SECURE_NO_DEPRECATE" /D"WIN32_LEAN_AND_MEAN" /D"NOMINMAX" /D"UNICODE" /D"_UNICODE" /D"_CONSOLE"
LDFLAGS32=
LDFLAGS64= $(LIBARG64) /LIBPATH:$(LIBDIR64) /DEF:"jxlwic.def" /MACHINE:X64

dll64: setup verfile
	$(CC) /c $(SRCARG) $(CFLAGS)
	link.exe /dll /out:$(RELEASEBINDIR64)/$(TITLE).dll $(TEMPDIR)/*.obj $(LDFLAGS64)
	echo F | xcopy /E /Y /F $(BINDIR64)\* $(RELEASEBINDIR64)
	del /Q $(RELEASEBINDIR64)\*.exp
	del /Q $(RELEASEBINDIR64)\*.lib

verfile:
	@echo build_date: > $(VERFILE)
	date /T >> $(VERFILE)
	@echo build_host: >> $(VERFILE)
	hostname >> $(VERFILE)
	@echo author: >> $(VERFILE)
	echo %username% >> $(VERFILE)
	@echo revision: >> $(VERFILE)
	@- git rev-parse --verify HEAD >> $(VERFILE)
	@echo url: >> $(VERFILE)
	@- git config --get remote.origin.url  >> $(VERFILE)

setup:
	- if NOT EXIST "$(RELEASEDIR)" mkdir "$(RELEASEDIR)"
	- if NOT EXIST "$(RELEASEINCDIR)" mkdir "$(RELEASEINCDIR)"
	- if NOT EXIST "$(RELEASEBINDIR32)" mkdir "$(RELEASEBINDIR32)"
	- if NOT EXIST "$(RELEASELIBDIR32)" mkdir "$(RELEASELIBDIR32)"
	- if NOT EXIST "$(RELEASEBINDIR64)" mkdir "$(RELEASEBINDIR64)"
	- if NOT EXIST "$(RELEASELIBDIR64)" mkdir "$(RELEASELIBDIR64)"
	- if NOT EXIST "$(TEMPDIR)" mkdir "$(TEMPDIR)"

clean: cleantmp
	rm -r -f $(RELEASEDIR)

cleantmp:
	rm -r -f $(TEMPDIR)
	rm -r -f *.idb
	rm -f -f *.pdb
