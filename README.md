# Wayfarer.Overwatch

Note: To make Godot "find" the actual plugin script (EditorOverwatch.cs in the root), you have to do a few things after cloning this:

i : Exclude the Plugin.cs from the Wayfarer project

ii : Add the Plugin.cs to the main project generated by Godot

After this, make sure that the right repo is tracking the file (i.e not the main project itself, but this one) even if it's included in the main project.
