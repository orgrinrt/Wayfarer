using System;
using Godot;
using Wayfarer.ModuleSystem;
using Wayfarer.Utils.Debug;
using Wayfarer.Utils.Files;
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

        public void InitializeStatics()
        {
            try
            {
                Log.Initialize();
            }
            catch (Exception e)
            {
                GD.PushError("Couldn't initialize Log");
                GD.Print(e);
            }

            try
            {
                Directories.Initialize();
            }
            catch (Exception e)
            {
                GD.PushError("Couldn't initialize Log");
                GD.Print(e);
            }
            
            try
            {
                WayfarerProjectSettings.Initialize();
            }
            catch (Exception e)
            {
                GD.PushError("Couldn't initialize Log");
                GD.Print(e);
            }
        }

        public void DisposeStatics()
        {
            try
            {
                Log.Dispose();
            }
            catch (Exception e)
            {
                GD.PushError("Couldn't dispose Log");
                GD.Print(e);
            }
        }

        public Godot.Collections.Array GetChildrenRecursive(Node node)
        {
            return node.GetChildrenRecursive().ToArray();
        }
    }
}