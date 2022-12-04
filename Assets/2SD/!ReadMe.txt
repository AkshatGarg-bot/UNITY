FAQ

-Where is the scene shown on the screenshots?
2SD\Terrain Packs\Snowy Mountains\Scene

-My scene looks completely different, why? 
Most likely your project is in Gamma color space instead of Linear. 
Edit\Player\Other Settings\Color Space 
Also make sure your camera is set to deferred instead of forward

-I don't want the included post effects(VolumetricFog & SSMS), can I delete them?
Yes, but don't forget to delete the scripts from the camera as well. These are located in 
2SD\_Open Source Packages\

-How can I change the falling snow?
Open the included scene, in the Hierarchy panel go to 
Particle Systems\Dynamic Particle Systems\Particle System Fake Snow
This particle system has a special shader which lets you change the amount of snow("snow strength" slider),  and since this is a hybrid shader-particle based approach you can also change the particle system as well as usual. The dynamic snow particles also have a script attached to them(objectAttach.cs), this simply follows the object specified in the inspector(the camera).

-What are the files in the Shaders\Functions folder?
If you have the Amplify Shader Editor you can use these to create your own shaders(or customize the included ones). Shader functions are basically small(well, usually small) reusable parts. You can delete them if you don't want to create your own shaders.

-How is the included BillboardTree different than the built in one? 
It works with depth of field(not affected by volumetric lights though)