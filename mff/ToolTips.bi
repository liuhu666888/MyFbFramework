﻿'################################################################################
'#  ToolTips.bi                                                                  #
'#  This file is part of MyFBFramework                                            #
'#  Version 1.0.0                                                                  #
'################################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QToolTips(__Ptr__) *Cast(ToolTips Ptr, __Ptr__)
    
    Type ToolTips Extends Control
        Private:
            Declare Static Sub WndProc(ByRef Message As Message)
            Declare Sub ProcessMessage(ByRef Message As Message)
            Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
        Public:
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Constructor
            Declare Destructor
    End Type
    
    Sub ToolTips.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
        If Sender.Child Then
            With QToolTips(Sender.Child)
                 
            End With
        End If
    End Sub

    Sub ToolTips.WndProc(ByRef Message As Message)
    End Sub

    Sub ToolTips.ProcessMessage(ByRef Message As Message)
    End Sub

    Operator ToolTips.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor ToolTips
        With This
            .RegisterClass "ToolTips","tooltips_class32"
            .ClassName = "ToolTips"
            .ClassAncestor = "tooltips_class32"
            .Style        = WS_CHILD
            .ExStyle      = 0
            .Width        = 175
            .Height       = 21
            .Child        = @This
            .ChildProc    = @WndProc
            .OnHandleIsAllocated = @HandleIsAllocated
        End With
    End Constructor

    Destructor ToolTips
        UnregisterClass "ToolTips",GetModuleHandle(NULL)
    End Destructor
End Namespace
