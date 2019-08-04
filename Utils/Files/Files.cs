using Godot;
using Array = Godot.Collections.Array;
using Object = Godot.Object;

namespace Wayfarer.Utils.Files
{
    public class Files
    {
        private static Object _gdFileUtils;
        
        public static Array FilterDefault = new Array { "*" };
        public static Array FilterModuleMeta = new Array { "wfmodule.tres" };
        public static Array FilterPebble = new Array { "*.pebble" };
        public static Array FilterPebbler = new Array { "*.pebbler" };
        public static Array FilterRes = new Array { "*.tres" };
        public static Array FilterScene = new Array { "*.tscn" };
        
        public static Object GdFileUtils => GetGdFileUtils();

        public static Array GetFilesFromDir(string dirPath, bool returnAsPath = true, Array filter = null)
        {
            if (filter == null)
            {
                filter = FilterDefault;
            }

            Array result = (Array) GdFileUtils.Call("get_files_from_dir", dirPath, returnAsPath, filter);
        
            return result;
        }

        public static bool HasPlugin()
        {
            if (GdFileUtils.Get("plugin") == null)
            {
                return false;
            }
            else return true;
        }

        public static bool HasPlugin(EditorPlugin plugin)
        {
            if (!HasPlugin())
            {
                SetPlugin(plugin);
            }

            return true;
        }

        public static void SetPlugin(EditorPlugin plugin)
        {
            GdFileUtils.Call("set_plugin", plugin);
        }
        
        private static Object GetGdFileUtils()
        {
            if (_gdFileUtils != null) return _gdFileUtils;
            
            GDScript script = GD.Load<GDScript>("res://Addons/Wayfarer/file_utils.gd");
            _gdFileUtils = script.New();
            return _gdFileUtils;
        }
    }
}