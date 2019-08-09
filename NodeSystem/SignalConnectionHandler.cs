using System;
using System.Collections.Generic;
using Wayfarer.Utils.Debug;
using Wayfarer.Utils.Debug.Exceptions;
using Object = Godot.Object;

namespace Wayfarer.NodeSystem
{
    public class SignalConnectionHandler
    {
        private Queue<SignalConnectionHandle> _failed = new Queue<SignalConnectionHandle>();
        private Queue<SignalConnectionHandle> _pending = new Queue<SignalConnectionHandle>();
        private int _acceptedFailTimes = 20;

        public Queue<SignalConnectionHandle> Pending => _pending;
        public int AcceptedFailTimes => _acceptedFailTimes;

        public void Add(SignalConnectionHandle handle)
        {
            if (!_pending.Contains(handle))
            {
                _pending.Enqueue(handle);
            }
        }

        public void Add(Object emitter, string signalName, Object listener, string methodName)
        {
            SignalConnectionHandle handle = new SignalConnectionHandle(emitter, signalName, listener, methodName);

            if (!_pending.Contains(handle))
            {
                _pending.Enqueue(handle);
            }
        }

        public void Add(Func<Object> getEmitterMethod, string signalName, Object listener, string methodName)
        {
            SignalConnectionHandle handle = new SignalConnectionHandle(getEmitterMethod, signalName, listener, methodName);

            if (!_pending.Contains(handle))
            {
                _pending.Enqueue(handle);
            }
        }
        
        public void Add(string signalName, Object self, string methodName)
        {
            SignalConnectionHandle handle = new SignalConnectionHandle(self, signalName, self, methodName);

            if (!_pending.Contains(handle))
            {
                _pending.Enqueue(handle);
            }
        }

        public void Update()
        {
            if (_pending.Count <= 0) return;
            
            _failed.Clear();

            SignalConnectionHandle handle;
            while (_pending.Count > 0)
            {
                handle = _pending.Dequeue();

                if (handle.Emitter == null && handle.GetEmitterMethod != null)
                {
                    try
                    {
                        handle.SetEmitter(handle.GetEmitterMethod());
                    }
                    catch (Exception e)
                    {
                        Log.Wf.Error("Failed to get emitter from GetEmitterMethod" + " FAILS: " + (handle.FailTimes + 1), true);
                        handle.Fail();
                        
                        if (handle.FailTimes < AcceptedFailTimes)
                        {
                            _failed.Enqueue(handle);
                        }
                        
                        continue;
                    }
                }

                if (handle.Emitter != null && handle.Listener != null)
                {
                    try
                    {
                        handle.Emitter.Connect(handle.Signal, handle.Listener, handle.Method);
                    }
                    catch (Exception e)
                    {
                        Log.Wf.Error("Failed to connect signal " + handle.Signal + " to " + handle.Listener + "'s method " + handle.Method + " FAILS: " + (handle.FailTimes + 1), true);
                        handle.Fail();

                        if (handle.FailTimes < AcceptedFailTimes)
                        {
                            _failed.Enqueue(handle);
                        }
                    }
                }
                else
                {
                    Log.Wf.Error("Both Emitter and Listener were null when trying to connect a signal" + " FAILS: " + (handle.FailTimes + 1), true);
                    handle.Fail();
                    
                    if (handle.FailTimes < AcceptedFailTimes)
                    {
                        _failed.Enqueue(handle);
                    }
                    else
                    {
                        throw new SignalConnectFailedException("Attempted to connect signal 10 times, didn't work, terminating connection completely and crashing!");
                    }
                }
            }

            _pending.Clear();
            _pending = _failed;
        }
    }
}