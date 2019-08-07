using System;
using System.Collections.Generic;
using System.Linq;
using Godot;
using Wayfarer.Utils.Debug;
using Wayfarer.Utils.Files;
using Array = Godot.Collections.Array;

namespace Wayfarer.ModuleSystem
{
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
            _resource = null;
            
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

            try
            {
                Log.Wf.Editor("ModuleMeta's parent path = " + parentPath);

                Array result = Files.GetFilesFromDir(parentPath, true, Files.FilterModuleMeta);

                if (result != null)
                {
                    if (result.Count > 0)
                    {
                        _resource = GD.Load((string) result[0]);
                        _name = (string) _resource.Get("name");
                        _desc = (string) _resource.Get("desc");
                        _version = (string) _resource.Get("version");
                        _deps = (Array) _resource.Get("deps");
                        _depsVersions = (Array) _resource.Get("deps_vers");
                        return;
                    }
                    else
                    {
                        throw new IndexOutOfRangeException("Resulting Godot.Array was smaller than 1");
                    }
                }
                else
                {
                    throw new NullReferenceException("Resulting Godot.Array was null");
                }
            }
            catch (Exception e)
            {
                Log.Wf.Error("Couldn't get the ModuleMeta for " + reference.Name + " with a Files.GetFilesFromDir() call...", true);
            }

            if (_resource == null)
            {
                Log.Wf.Editor("    ...attempting to load wfmodule.tres directly...", true);
                
                Resource result = GD.Load(parentPath + "/wfmodule.tres");
                
                if (result != null)
                {
                    _resource = result;
                    _name = (string) _resource.Get("name");
                    _desc = (string) _resource.Get("desc");
                    _version = (string) _resource.Get("version");
                    _deps = (Array) _resource.Get("deps");
                    _depsVersions = (Array) _resource.Get("deps_vers");

                    Log.Wf.Editor("    ...AND THIS TIME IT WAS A SUCCESS!", true);
                    return;
                }
                else
                {
                    throw new NullReferenceException("Direct load (" + parentPath + "/wfmodule.tres) failed too");
                }
            }
            
            _resource = null;
            _name = "";
            _desc = "";
            _version = "";
            _deps = null;
            _depsVersions = null;
            
            throw new ApplicationException("Couldn't instantiate ModuleMeta");
        }
    }
}