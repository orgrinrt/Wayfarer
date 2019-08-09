using System;
using Object = Godot.Object;

namespace Wayfarer.NodeSystem
{
    public class SignalConnectionHandle
    {
        private Func<Object> _getEmitterMethod;
        private Object _emitter;
        private string _signal;
        private Object _listener;
        private string _method;
        private int _failTimes = 0;

        public Func<Object> GetEmitterMethod => _getEmitterMethod;
        public Object Emitter => _emitter;
        public string Signal => _signal;
        public Object Listener => _listener;
        public string Method => _method;
        public int FailTimes => _failTimes;

        public SignalConnectionHandle(Object emitter, string signalName, Object listener, string methodName)
        {
            _emitter = emitter;
            _signal = signalName;
            _listener = listener;
            _method = methodName;
            _failTimes = 0;
        }
        
        public SignalConnectionHandle(Func<Object> getEmitterMethod, string signalName, Object listener, string methodName)
        {
            _getEmitterMethod = getEmitterMethod;
            _signal = signalName;
            _listener = listener;
            _method = methodName;
            _failTimes = 0;
        }

        public void Fail()
        {
            _failTimes++;
        }

        public void SetEmitter(Object emitter)
        {
            _emitter = emitter;
        }
    }
}