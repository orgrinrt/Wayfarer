using Godot;

namespace Wayfarer.Utils.Helpers
{
    public static class Textures
    {
        public static Vector2 TexturePixelSizeToScale(Vector2 sourceSize, int targetHeight, int targetWidth)
        {
            return new Vector2(sourceSize.x / (sourceSize.x / targetWidth) / 250, (sourceSize.y / (sourceSize.y / targetHeight)) / 250);
        }

        public static ImageTexture RadialGradient(int width, int height, Gradient gradient)
        {
            Image image = new Image();
            
            image.Create(width, height, true, Image.Format.Rgb8);
            image.Lock();

            Color[,] colors = Gradients.RadialGradient(width, height, gradient);

            for (int x = 0; x < width; x++)
            {
                for (int y = 0; y < height; y++)
                {
                    image.SetPixel(x, y, colors[x, y]);
                }
            }
            
            image.Unlock();
            
            ImageTexture tex = new ImageTexture();
            tex.CreateFromImage(image);

            return tex;
        }

        
    }
}