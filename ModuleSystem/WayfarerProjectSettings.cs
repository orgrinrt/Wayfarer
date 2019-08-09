using System;
using Godot;
using Godot.Collections;
using Wayfarer.Utils.Debug;
using Array = Godot.Collections.Array;

namespace Wayfarer.ModuleSystem
{
    public static class WayfarerProjectSettings
    {
        private static Resource _resource;
        private static Array _installedModules;
        private static Dictionary _settings;
        
        public static Resource Resource => _resource;
        public static bool ResetOnReady => GetResetOnReady();

        static WayfarerProjectSettings()
        {
            try
            {
                Initialize();
            }
            catch (Exception e)
            {
                Console.WriteLine("Couldn't initialize WayfarerProjectSettings (static)");
                
                Initialize();
            }
        }

        public static void Initialize()
        {
            _resource = GD.Load("res://wfsettings.tres");

            _installedModules = (Array) _resource.Get("installed_modules");
            _settings = (Dictionary) _resource.Get("settings");
        }

        public static object Get(string settingPath)
        {
            if (_settings.ContainsKey(settingPath))
            {
                Dictionary presentValue = (Dictionary)_settings[settingPath];

                if (presentValue?["value"] != null)
                {
                    return presentValue["value"];
                }
                else
                {
                    throw new NullReferenceException("The value for \"" + settingPath + "\" was null or didn't exist");
                }
            }
            
            return null;
        }
        
        public static void Add(string settingPath, object value, string desc = "")
        {
            if (!_settings.ContainsKey(settingPath))
            {
                Dictionary settingValues = new Dictionary {{"value", value}, {"desc", desc}};

                _settings.Add(settingPath, settingValues);
            }
        }
        
        public static void AddOrUpdate(string settingPath, object value, string desc = "")
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

        public static void Update(string settingPath, object value)
        {
            // we might want to make a more streamlined version of AddSetting for updating purposes - for now we'll just wrap it
            AddOrUpdate(settingPath, value);
        }

        public static bool Contains(string settingPath)
        {
            return _settings.ContainsKey(settingPath);
        }

        private static bool GetResetOnReady()
        {
            bool value = true;
            
            try
            {
                value = (bool) _resource.Get("reset_on_ready");
                return value;
            }
            catch (Exception e)
            {
                Log.Wf.Error("Tried to get \"reset_on_ready\" from WayfarerProjectSettings but couldn't", e, true);
            }
            
            Log.Wf.Error("Couldn't get ResetOnReady from the settings resource", true);

            return value;
        }
    }
}