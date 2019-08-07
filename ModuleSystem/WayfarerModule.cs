#if TOOLS

using System;
using System.Runtime.CompilerServices;
using Godot;
using Godot.Collections;
using Wayfarer.Utils.Debug;
using Array = Godot.Collections.Array;
using Object = Godot.Object;

namespace Wayfarer.ModuleSystem
{
    [Tool]
    public class WayfarerModule : EditorPlugin
    {
        public string ModuleName => GetModuleName();
        public string ModuleDescription => GetModuleDesc();
        public string ModuleVersion => GetModuleVersion();
        public Array ModuleDependencies => GetModuleDependencies();
        public Array ModuleDependencyVersions => GetModuleDependencyVersions();
        public ModuleMeta ModuleMeta => GetModuleMeta();
        public bool? ResetOnReady => WayfarerProjectSettings.ResetOnReady;

        private bool _cachedResetOnReady = true;

        public override void _EnterTree()
        {
            base._EnterTree();
            
            if (ResetOnReady != null)
            {
                _cachedResetOnReady = (bool)ResetOnReady;
                
                if ((bool)ResetOnReady) return;
                
                Log.Wf.Print("ResetOnReady was false - this must be the OW reset after launch!", true);
                
                EnablePlugin();
                _EnterTreeSafe();
            }
            else
            {
                throw new NullReferenceException("ResetOnReady was null");
            }
        }

        public override void _Ready()
        {
            base._Ready();
            
            if (_cachedResetOnReady) return;
            
            try
            {
                Name = ModuleName;
            }
            catch (Exception e)
            {
                Log.Wf.Error("Couldn't set the plugin's (" + Name + ") name to ModuleName", e, true);
            }

            _ReadySafe();
        }

        public override void _ExitTree()
        {
            base._ExitTree();
            _ExitTreeSafe();
            DisablePlugin();
        }

        public virtual void _EnterTreeSafe()
        {
            
        }

        public virtual void _ReadySafe()
        {
            
        }

        public virtual void _ExitTreeSafe()
        {
            
        }

        private Dictionary GetWayfarerSettingsDictionary()
        {
            // The Key is the settingPath (i.e general/input/xyz)
            // The value is another Dictionary that contains
            //     value: <object>
            //     desc: <string>
            Resource settingRes = GD.Load("res://wfsettings.tres");

            Dictionary settings = (Dictionary) settingRes.Get("settings");

            return settings;
        }

        private ModuleMeta GetModuleMeta()
        {
            return new ModuleMeta(this);
        }

        private string GetModuleName()
        {
            return ModuleMeta.Name;
        }

        private string GetModuleDesc()
        {
            return ModuleMeta.Desc;
        }

        private string GetModuleVersion()
        {
            return ModuleMeta.Version;
        }

        private Array GetModuleDependencies()
        {
            return ModuleMeta.Deps;
        }

        private Array GetModuleDependencyVersions()
        {
            return ModuleMeta.DepsVersions;
        }
    }
}

#endif