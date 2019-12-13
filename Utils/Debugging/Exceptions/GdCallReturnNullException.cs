using System;

namespace Wayfarer.Utils.Debug.Exceptions
{
    public class GdCallReturnNullException : GdCallFailedException
    {
        public GdCallReturnNullException()
        {
            
        }

        public GdCallReturnNullException(string message) : base(message)
        {
            
        }

        public GdCallReturnNullException(string message, Exception inner) : base(message, inner)
        {
            
        }
    }
}