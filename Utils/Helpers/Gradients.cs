using Godot;

namespace Wayfarer.Utils.Helpers
{
    public class Gradients
    {
        public static Color[,] RadialGradient(int width, int height, Gradient gradient)
        {
            Color[,] data = new Color[width, height];
            Vector2 size = new Vector2(width, height);
            Vector2 radius = (size - new Vector2(1, 1)) / 2;
            float ratio = size.x / size.y;

            for (int x = 0; x < width; x++)
            {
                for (int y = 0; y < height; y++)
                {
                    float dist = new Vector2(x / ratio, y).DistanceTo(new Vector2(radius.x / ratio, radius.y));
                    float offset = dist / radius.y;
                    Color color = gradient.Interpolate(offset);
                    data[x, y] = color;
                }
            }

            return data;
        }
    }
}