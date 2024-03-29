﻿using System;
using System.IO;
using Wayfarer.Utils.Debug;

namespace Wayfarer.Utils.Files
{
    public static class Directories
    {
        public static DirectoryInfo PebblesRoot => GetWayfarerPebblesRootDirectory();
        public static DirectoryInfo WayfarerLogRoot => GetWayfarerLogRootDirectory();
        
        static Directories()
        {
            try
            {
                Initialize();
            }
            catch (Exception e)
            {
                Log.Error("Tried to initialize Directories() but couldn't", e, true);
            }
        }

        public static void Initialize()
        {/*
            GetWayfarerLogRootDirectory();
            GetWayfarerPebblesRootDirectory();*/
        }

        private static DirectoryInfo GetWayfarerPebblesRootDirectory()
        {
            return Directory.CreateDirectory(Paths.PebblesPath);
        }

        private static DirectoryInfo GetWayfarerLogRootDirectory()
        {
            return Directory.CreateDirectory(Paths.WayfarerLogPath);
        }
    }
}