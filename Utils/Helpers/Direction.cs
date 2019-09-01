using Godot;

namespace Wayfarer.Utils.Helpers
{
    public static class Direction
    {
        public static Vector2 Right2D = new Vector2(1,0);
        public static Vector2 Left2D = new Vector2(-1,0);
        public static Vector2 Up2D = new Vector2(0,-1);
        public static Vector2 Down2D = new Vector2(0,1);
        
        public static Vector3 Down = new Vector3(0, -1, 0);
        public static Vector3 Up = new Vector3(0, 1, 0);

        public static Vector2 GetNormalized(Vector2 origin, Vector2 target)
        {
            return (target - origin).Normalized();
        }
    }
    
    public enum Direction2D : byte
    {
        Left = 1,
        Right = 2,
        Up = 4,
        Down = 8
    }
    
    public enum Direction3D : byte
    {
        North = 1,
        South = 2,
        West = 4,
        East = 8,
        Up = 16,
        Down = 32
    }
}