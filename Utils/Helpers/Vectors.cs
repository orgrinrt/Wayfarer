using Godot;

namespace Wayfarer.Utils.Helpers
{
    public static class Vectors
    {
        public static Vector2 Zero2 = new Vector2(0, 0);
        public static Vector3 Zero3 = new Vector3(0, 0, 0);
    }

    public struct Vector3Int
    {
        private int _x;
        private int _y;
        private int _z;

        public int x => _x;
        public int y => _y;
        public int z => _z;

        public Vector3Int(int x, int y, int z)
        {
            _x = x;
            _y = y;
            _z = z;
        }
    }
}