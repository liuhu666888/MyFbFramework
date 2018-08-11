﻿'******************************************************************************
'* ClipboardType
'* This file is part of MyFBFramework
'* 2017
'******************************************************************************
 
Namespace My.Sys
    Type ClipboardType
        Private:
            FFormatCount As Integer
            FFormat      As WString Ptr
            FText        As WString Ptr
        Public:
            Declare Sub Open
            Declare Sub Clear
            Declare Sub Close
            Declare Sub SetAsText(ByRef Value As WString)
            Declare Function GetAsText ByRef As WString
            Declare Sub SetAsHandle(FFormat As Word, Value As HANDLE)
            Declare Function GetAsHandle(FFormat As Word) As HANDLE
            Declare Function HasFormat(FFormat As Word) As Boolean
            Declare Property FormatCount As Integer
            Declare Property FormatCount(Value As Integer)
            Declare Property Format ByRef As WString
            Declare Property Format(ByRef Value As WString)
            Declare Constructor
            Declare Destructor
    End Type

    Sub ClipboardType.Open
        OpenClipboard(NULL)
    End Sub

    Sub ClipboardType.Clear
        EmptyClipboard
    End Sub

    Sub ClipboardType.Close
        CloseClipboard
    End Sub

    Function ClipboardType.HasFormat(FFormat As Word) As Boolean
        Return IsClipboardFormatAvailable(FFormat)
    End Function

    Sub ClipboardType.SetAsText(ByRef Value As WString)
        Dim pchData As WString Ptr
        Dim hClipboardData As HGLOBAL
        Dim sz As Integer
        This.Open
        This.Clear
        sz = (Len(value) + 1) * SizeOf(WString)
        hClipboardData = GlobalAlloc(NULL, sz)
        pchData = Cast(WString Ptr, GlobalLock(hClipboardData))
        memcpy(pchData, @Value, sz)
        SetClipboardData(CF_UNICODETEXT, hClipboardData)
        GlobalUnlock(hClipboardData)
        This.Close
    End Sub

    Function ClipboardType.GetAsText ByRef As WString
        Dim hClipboardData As HANDLE
        This.Open
        hClipboardData = GetClipboardData(CF_UNICODETEXT)
        If hClipboardData <> 0 Then
            WLet FText, *CPtr(WString Ptr, GlobalLock(hClipboardData))
            GlobalUnlock(hClipboardData)
        Else
            WLet FText, ""
        End If
        This.Close
        Return *FText
    End Function

    Sub ClipboardType.SetAsHandle(FFormat As Word,Value As HANDLE)
        This.Open
        This.Clear
        SetClipboardData(FFormat, Value)
        This.Close
    End Sub

    Function ClipboardType.GetAsHandle(FFormat As Word) As HANDLE
        This.Open
        Function = GetClipboardData(FFormat)
        This.Close
    End Function

    Property ClipboardType.FormatCount As Integer
        Return CountClipboardFormats
    End Property

    Property ClipboardType.FormatCount(Value As Integer)
    End Property

    Property ClipboardType.Format ByRef As WString
        Dim s As String = Space(255)
        Dim i As Integer, IFormat As UINT
        i = GetClipboardFormatName(IFormat,s,255)
        FFormat = Cast(WString Ptr, ReAllocate(FFormat, (i + 1) * SizeOf(WString))) 
        *FFormat = Left(s, i)
        Return *FFormat
    End Property

    Property ClipboardType.Format(ByRef Value As WString)
        FFormat = Cast(WString Ptr, ReAllocate(FFormat, (Len(Value) + 1) * SizeOf(WString))) 
        *FFormat = Value + Chr(0)
        RegisterClipboardFormat(FFormat) 
    End Property

    Constructor ClipboardType
    End Constructor

    Destructor ClipboardType
        If FText Then Deallocate FText
    End Destructor
End Namespace

Dim Shared As My.Sys.ClipboardType Clipboard
