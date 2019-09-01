using System;
using System.IO.Ports;
using System.Threading;

namespace Wayfarer.Utils.Threading
{
    public abstract class ThreadedProcess : IDisposable
    {
        private bool _isDone = false;
        private object _handle = new object();
        private Thread _thread;

        public bool IsDone => CheckIfDone();

        public virtual void Start()
        {
            _thread = new Thread(Run);
            _thread.Start();
        }

        public virtual void Abort()
        {
            _thread.Abort();
        }

        public virtual bool Update()
        {
            if (CheckIfDone())
            {
                OnFinished();
                return true;
            }
            return false;
        }
        
        private void Run()
        {
            Logic();
            
            _isDone = true;
        }

        protected abstract void Logic();

        protected virtual void OnFinished()
        {
            
        }

        private bool CheckIfDone()
        {
            bool isDone = false;
            
            lock (_handle)
            {
                isDone = _isDone;
            }

            return isDone;
        }

        protected void Done()
        {
            _isDone = true;
        }

        public virtual void Dispose()
        {
            Abort();
            _handle = null;
            _thread = null;
        }
    }
}