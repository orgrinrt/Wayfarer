#if TOOLS

using System;
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
        
        private TopRightPanel _topRightPanel;
        
        public override void _EnterTree()
        {
            Log.Instantiate();
            AddCustomControlsToEditor();
        }

        public override void _ExitTree()
        {
            RemoveCustomControlsFromEditor();
        }

        public override void DisablePlugin()
        {
            base.DisablePlugin();

            RemoveOldTopRightPanel();
        }

        private void AddCustomControlsToEditor()
        {
            //RemoveOldTopRightPanel();

            PackedScene topRightScene = GD.Load<PackedScene>("res://Addons/Wayfarer/Assets/Scenes/Controls/TopRightPanel.tscn");
            _topRightPanel = (TopRightPanel) topRightScene.Instance();
            _topRightPanel.SetPluginManager(this);
            AddControlToContainer(CustomControlContainer.Toolbar, _topRightPanel);

        }

        private void RemoveOldTopRightPanel()
        {
            try
            {
                Node[] editorNodes = EditorInterface.GetBaseControl().GetChildrenRecursive();

                foreach (Node node in editorNodes)
                {
                    if (node is TopRightPanel)
                    {
                        try
                        {
                            RemoveControlFromContainer(CustomControlContainer.Toolbar, node as Control);
                            Log.Editor("Removed old TopRightPanel (RemoveControl)", true);
                        }
                        catch (Exception e)
                        {
                            Log.Editor("Tried to remove TopRightPanel from Toolbar, but couldn't", true);
                        }
                        try
                        {
                            node.QueueFree();
                            Log.Editor("Removed old TopRightPanel (QueueFree)", true);
                        }
                        catch (Exception e)
                        {
                            Log.Editor("Tried to QueueFree() TopRightPanel from Toolbar, but couldn't", true);
                        }
                        return;
                    }
                }
            }
            catch (Exception e)
            {
                
                
                Log.Editor(e.Message, true);
                
            }
            
        }

        private void RemoveCustomControlsFromEditor()
        {
            RemoveControlFromContainer(CustomControlContainer.Toolbar, _topRightPanel);

            _topRightPanel.QueueFree();
        }
    }
}

#endif