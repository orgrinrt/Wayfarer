#if TOOLS

using System.Configuration;
using Godot;
using Wayfarer.Overwatch;
using Wayfarer.Utils.Attributes;
using Wayfarer.Utils.Debug;
using Wayfarer.Utils.Helpers;

namespace Wayfarer.Core.Plugin
{
    [Tool]
    public class TopRightPanel : Control
    {
        [Get("Reset")] private Button _resetButton;

        private EditorOverwatch _overwatch;
        
        public override void _Ready()
        {
            this.SetupWayfarer();

            _resetButton.Connect("button_up", this, nameof(OnResetPressed));
            
            Log.Editor("TopRightPanel Ready");
        }

        private void OnResetPressed()
        {
            ResetWayfarerCore();
        }

        private void ResetWayfarerCore()
        {
            if (_overwatch.EditorInterface.IsPluginEnabled("Wayfarer"))
            {
                _overwatch.EditorInterface.SetPluginEnabled("Wayfarer", false);
                Log.Editor("Wayfarer plugin active state: " + _overwatch.EditorInterface.IsPluginEnabled("Wayfarer"), true);
                _overwatch.EditorInterface.SetPluginEnabled("Wayfarer", true);
                Log.Editor("Wayfarer plugin active state: " + _overwatch.EditorInterface.IsPluginEnabled("Wayfarer"), true);
            }
        }

        public void SetPluginManager(EditorOverwatch overwatch)
        {
            _overwatch = overwatch;
        }
    }
}

#endif