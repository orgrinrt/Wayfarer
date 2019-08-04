using Godot;
using Wayfarer.Utils.Debug;
using Wayfarer.Utils.Helpers;

namespace Wayfarer.Utils
{
    #if TOOLS
    [Tool]
    #endif
    public class Gd : Node
    {
        public void Print(string print, bool gdPrint = false)
        {
            Log.Print(print, gdPrint);
        }
        
        public void PrintWf(string print, bool gdPrint = false)
        {
            Log.Wf.Print(print, gdPrint);
        }

        public void Test()
        {
            Log.Print("HAHAHA", true);
            
        }

        public Godot.Collections.Array GetChildrenRecursive(Node node)
        {
            return node.GetChildrenRecursive().ToArray();
        }
    }
}