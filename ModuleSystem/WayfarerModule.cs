#if TOOLS

using System;
using System.Collections.Generic;
using System.Linq;
using Godot;
using Godot.Collections;
using Wayfarer.Utils.Debug;
using Wayfarer.Utils.Files;
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
        public WayfarerProjectSettings WayfarerProjectSettings => GetWayfarerSettings();

        public override void _EnterTree()
        {
            base._EnterTree();
            EnablePlugin();
        }

        public override void _Ready()
        {
            base._Ready();
            
            Name = ModuleName;
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

        private WayfarerProjectSettings GetWayfarerSettings()
        {
            return new WayfarerProjectSettings();
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

        public string Name => _name;
        public string Desc => _desc;
        public string Version => _version;
        public Array Deps => _deps;
        public Array DepsVersions => _depsVersions;

        public ModuleMeta(WayfarerModule reference)
        {
            string path = (string) reference.GetScript().Get("resource_path");
            string[] split = path.Split("/");
            List<string> pathParts = split.ToList();
            pathParts.RemoveAt(pathParts.Count - 1);
            string parentPath = "";

            foreach (string s in pathParts)
            {
                if (s.StartsWith("res:"))
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
        }
    }

    public class WayfarerProjectSettings
    {
        private Resource _resource;
        public Resource Resource => _resource;

        private Array _installedModules;
        private Dictionary _settings;

        public WayfarerProjectSettings()
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