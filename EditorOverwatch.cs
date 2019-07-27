#if TOOLS

using Godot;
using Wayfarer.Core.Plugin;
using Wayfarer.Utils.Debug;
using Wayfarer.Utils.Helpers;

namespace Wayfarer.Overwatch
{
    [Tool]
    public class EditorOverwatch : EditorPlugin
    {
        public EditorInterface EditorInterface => GetEditorInterface();
        
        public override void _EnterTree()
        {
            
        }

        public override void _ExitTree()
        {
            
        }

        public override bool Build() // NOT WORKING CURRENTLY, this does nothing
        {
            if (!EditorInterface.IsPluginEnabled("Wayfarer"))
            {
                Log.Editor("Solution was built, so removing the old EditorMenuBar...", true);
                RemoveOldEditorMenubar();
            }
            
            return base.Build();
        }
        
        private void RemoveOldEditorMenubar() // consider somehow getting reference to Wayfarer Plugin.cs and the method there
        {
            Node[] editorNodes = EditorInterface.GetBaseControl().GetChildrenRecursive();

            foreach (Node node in editorNodes)
            {
                if (node is EditorMenuBar)
                {
                    RemoveControlFromContainer(CustomControlContainer.CanvasEditorMenu, node as Control);
                    node.QueueFree();
                    Log.Editor("Removed old EditorMenuBar", true);
                    return;
                }
            }
        }
    }
}

#endif