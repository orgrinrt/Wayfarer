using System;

namespace Wayfarer.Utils.Debug.Exceptions
{
    public class SignalConnectFailedException : Exception
    {
        public SignalConnectFailedException(string message = "Couldn't connect a signal") : base(message)
        {
            
        }

        public SignalConnectFailedException(Exception inner, string message = "Couldn't connect a signal") : base(message, inner)
        {
            
        }
    }
}