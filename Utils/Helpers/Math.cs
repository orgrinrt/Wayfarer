using Godot;

namespace Wayfarer.Utils.Helpers
{
    public static class Math
    {
        public static double RadianToDegree(double angle)
        {
            return angle * (180.0 / Mathf.Pi);
        }
        
        public static double DegreeToRadian(double angle)
        {
            return Mathf.Pi * angle / 180.0;
        }

        public static float Normalize(float raw, float min, float max)
        {
            return (raw - min) / (max - min);
        }
        
        public static double GetAngleDegree2D(Vector2 origin, Vector2 target) {
            var n = 270 - (Mathf.Atan2(origin.y - target.y, origin.x - target.x)) * 180 / Mathf.Pi;
            return n % 360;
        }

        public static float Distance(Vector2 a, Vector2 b)
        {
            /*
            return (Mathf.Pow(a.x-b.x,2)+Mathf.Pow(a.y-b.y,2));
            */
            return a.DistanceTo(b);
        }

        public static float Percentage(float input, float min, float max)
        {
            return ((input - min) * 100) / (max - min);
        }
        
        public static float PercentageAsDecimal(float input, float min, float max)
        {
            return (((input - min) * 100) / (max - min)) / 100;
        }
        
        public static double Clamp(double v, double l, double h)
        {
            if (v < l) v = l;
            if (v > h) v = h;
            return v;
        }

        public static double Lerp(double t, double a, double b)
        {
            return a + t * (b - a);
        }

        public static double QuinticBlend(double t)
        {
            return t * t * t * (t * (t * 6 - 15) + 10);
        }

        public static double Bias(float b, float t)
        {
            return Mathf.Pow(t, Mathf.Log(b) / Mathf.Log(0.5f));
        }

        public static double Gain(float g, float t)
        {
            if (t < 0.5)
            {
                return Bias(1.0f - g, 2.0f * t) / 2.0;
            }
            else
            {
                return 1.0 - Bias(1.0f - g, 2.0f - 2.0f * t) / 2.0;
            }
        }

        public static int Mod(int x, int m)
        {
            int r = x % m;
            return r < 0 ? r + m : r;
        }    
    }
}