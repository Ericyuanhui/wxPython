/////////////////////////////////////////////////////////////////////////////
// Name:        _timer.i
// Purpose:     SWIG interface definitions wxTimer
//
// Author:      Robin Dunn
//
// Created:     18-June-1999
// RCS-ID:      $Id$
// Copyright:   (c) 2003 by Total Control Software
// Licence:     wxWindows license
/////////////////////////////////////////////////////////////////////////////

// Not a %module


//---------------------------------------------------------------------------
%newgroup

enum {
    // generate notifications periodically until the timer is stopped (default)
    wxTIMER_CONTINUOUS,

    // only send the notification once and then stop the timer
    wxTIMER_ONE_SHOT,
};

// Timer event type
%constant wxEventType wxEVT_TIMER;
   

//---------------------------------------------------------------------------


%{
IMP_PYCALLBACK__(wxPyTimer, wxTimer, Notify);
%}



%name(Timer) class wxPyTimer : public wxEvtHandler
{
public:
    %addtofunc wxPyTimer         "self._setCallbackInfo(self, Timer)"

    // if you don't call SetOwner() or provide an owner in the contstructor
    // then you must override Notify() inorder to receive the timer
    // notification.  If the owner is set then it will get the timer
    // notifications which can be handled with EVT_TIMER.
    wxPyTimer(wxEvtHandler *owner=NULL, int id = -1);
    virtual ~wxPyTimer();

    void _setCallbackInfo(PyObject* self, PyObject* _class);

    // Set the owner instance that will receive the EVT_TIMER events using the
    // given id.
    void SetOwner(wxEvtHandler *owner, int id = -1);


    // start the timer: if milliseconds == -1, use the same value as for the
    // last Start()
    //
    // it is now valid to call Start() multiple times: this just restarts the
    // timer if it is already running
    virtual bool Start(int milliseconds = -1, bool oneShot = False);

    // stop the timer
    virtual void Stop();

    // override this in your wxTimer-derived class if you want to process timer
    // messages in it, use non default ctor or SetOwner() otherwise
    //virtual void Notify();

    // return True if the timer is running
    virtual bool IsRunning() const;

    // get the (last) timer interval in the milliseconds
    int GetInterval() const;

    // return True if the timer is one shot
    bool IsOneShot() const;
};


%pythoncode {    
%# For backwards compatibility with 2.4
class PyTimer(Timer):
    def __init__(self, notify):
        Timer.__init__(self)
        self.notify = notify

    def Notify(self):
        if self.notify:
            self.notify()


EVT_TIMER = wx.PyEventBinder( wxEVT_TIMER, 1 )
                   
};



class wxTimerEvent : public wxEvent
{
public:
    wxTimerEvent(int timerid = 0, int interval = 0);
    int GetInterval() const;
};



// wxTimerRunner: starts the timer in its ctor, stops in the dtor
class wxTimerRunner
{
public:
    %nokwargs wxTimerRunner;
    wxTimerRunner(wxTimer& timer);
    wxTimerRunner(wxTimer& timer, int milli, bool oneShot = False);
    ~wxTimerRunner();

    void Start(int milli, bool oneShot = False);
};


//---------------------------------------------------------------------------
