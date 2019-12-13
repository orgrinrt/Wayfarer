using System;

namespace Wayfarer.Utils.Debug.Exceptions
{
    public class GdCallFailedException : Exception
    {
        public GdCallFailedException()
        {
            
        }

        public GdCallFailedException(string message) : base(message)
        {
            
        }

        public GdCallFailedException(string message, Exception inner) : base(message, inner)
        {
            
        }
    }
}