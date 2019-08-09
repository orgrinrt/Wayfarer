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
        public bool ResetOnReady => WayfarerProjectSettings.ResetOnReady;

        private bool _cachedResetOnReady = true;

        public override void _EnterTree()
        {
            #if TOOLS
            _cachedResetOnReady = ResetOnReady;
            if (_cachedResetOnReady) return;
            #endif
            
            base._EnterTree();
            
            EnablePlugin();
            _EnterTreeSafe();
        }

        public override void _Ready()
        {
            #if TOOLS
            if (_cachedResetOnReady) return;
            #endif    
            
            base._Ready();
            
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
            #if TOOLS
            if (_cachedResetOnReady) return;
            #endif    
            
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