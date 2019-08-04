#if TOOLS

using System.Collections.Generic;
using System.Linq;
using Godot;
using Godot.Collections;
using Wayfarer.Utils.Debug;
using Wayfarer.Utils.Files;
using Array = Godot.Collections.Array;

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
        public WayfarerSettings WayfarerSettings => GetWayfarerSettings();

        public override void _EnterTree()
        {
            base._EnterTree();
            EnablePlugin();
        }

        public override void _Ready()
        {
            base._Ready();
            
            Name = ModuleName;
            GD.Print(Name);
        }

        public override void _ExitTree()
        {
            base._ExitTree();
            DisablePlugin();
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

        private WayfarerSettings GetWayfarerSettings()
        {
            return new WayfarerSettings();
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

    public struct ModuleMeta
    {
        private Resource _resource;
        public Resource Resource => _resource;

        private string _name;
        private string _desc;
        private string _version;
        private Array _deps;
        private Array _depsVersions;
        private WayfarerModule _ref;

        public string Name => _name;
        public string Desc => _desc;
        public string Version => _version;
        public Array Deps => _deps;
        public Array DepsVersions => _depsVersions;
        public WayfarerModule Ref => _ref;

        public ModuleMeta(WayfarerModule reference)
        {
            string path = (string) reference.GetScript().Get("resource_path");
            string[] split = path.Split("/");
            List<string> pathParts = split.ToList();
            pathParts.RemoveAt(pathParts.Count - 1);
            string parentPath = "";

            foreach (string s in pathParts)
            {
                if (s.StartsWith("res"))
                {
                    parentPath = s + "//";
                    continue;
                }

                if (s == "addons")
                {
                    parentPath = parentPath + "Addons" + "/";
                    continue;
                }
                parentPath = parentPath + s + "/";
            }

            parentPath = parentPath.Remove(parentPath.Length - 1);

            Files.HasPlugin(reference);
            
            Array result = Files.GetFilesFromDir(parentPath, true, Files.FilterModuleMeta);
    
            _resource = GD.Load((string)result[0]);

            _name = (string) _resource.Get("name");
            _desc = (string) _resource.Get("desc");
            _version = (string) _resource.Get("version");
            _deps = (Array) _resource.Get("deps");
            _depsVersions = (Array) _resource.Get("deps_vers");
            _ref = reference;
            if (_resource.Get("ref") == null)
            {
                _resource.Set("ref", reference);
                Log.Wf.Print("Ref was null, set reference to " + reference.Name, true);
            }
        }
    }

    public class WayfarerSettings
    {
        private Resource _resource;
        public Resource Resource => _resource;

        private Array _installedModules;
        private Dictionary _settings;

        public WayfarerSettings()
        {
            _resource = GD.Load("res://wfsettings.tres");

            _installedModules = (Array) _resource.Get("installed_modules");
            _settings = (Dictionary) _resource.Get("settings");
        }
        
        public void Add(string settingPath, object value, string desc = "")
        {
            if (_settings.ContainsKey(settingPath))
            {
                Dictionary presentValue = (Dictionary)_settings[settingPath];

                if (presentValue != null && presentValue["value"] != value)
                {
                    presentValue["value"] = value;
                }

                if (presentValue != null && (string) presentValue["desc"] != desc)
                {
                    if (!string.IsNullOrEmpty(desc))
                    {
                        presentValue["desc"] = desc;
                    }
                }
            }
            else
            {
                Dictionary settingValues = new Dictionary {{"value", value}, {"desc", desc}};

                _settings.Add(settingPath, settingValues);
            }
        }

        public void Update(string settingPath, object value)
        {
            // we might want to make a more streamlined version of AddSetting for updating purposes - for now we'll just wrap it
            Add(settingPath, value);
        }

        public bool Contains(string settingPath)
        {
            return _settings.ContainsKey(settingPath);
        }
    }
}

#endif