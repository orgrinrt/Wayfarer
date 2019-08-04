#if TOOLS

using System.Security;
using Godot;
using Godot.Collections;

namespace Wayfarer
{
    [Tool]
    public class WayfarerModule : EditorPlugin
    {
        public ModuleMeta ModuleMeta => GetModuleMeta();
        public Dictionary WayfarerSettings => GetWayfarerSettings();
        
        private Dictionary GetWayfarerSettings()
        {
            Resource settingRes = GD.Load("res://wfsettings.tres");

            Dictionary settings = (Dictionary) settingRes.Get("settings");

            return settings;
        }

        private ModuleMeta GetModuleMeta()
        {
            return new ModuleMeta(Name);
        }
    }

    public struct ModuleMeta
    {
        private Resource _metaResource;
        public Resource MetaResource => _metaResource;

        private string _name;
        private string _desc;
        private string _version;
        private Array _deps;
        private Array _depsVersions;

        public string Name => _name;
        public string Desc => _desc;
        public string Version => _version;
        public Array Deps => _deps;
        public Array DepsVersions => _depsVersions;

        public ModuleMeta(string moduleName)
        {
            _metaResource = GD.Load("res://Addons/" + moduleName + "/wfmodule.tres");

            _name = (string) _metaResource.Get("name");
            _desc = (string) _metaResource.Get("desc");
            _version = (string) _metaResource.Get("version");
            _deps = (Array) _metaResource.Get("deps");
            _depsVersions = (Array) _metaResource.Get("deps_vers");
        }
    }
}

#endif