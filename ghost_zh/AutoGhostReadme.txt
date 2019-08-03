ghost.zh
Version 2.7.0

General setup:

Extract ghost.zh and the ghost_zh directory from the zip file. On Windows and
Linux, these should go in the same directory as ZC itself. On Mac, right-click
ZQuest and select "Show Package Contents." The files should go in
Contents/Resources. To be sure you've got the right directory, look for
std.zh and sring.zh.

First, you'll need to set aside a 4x4 block of tiles to leave blank. Set up
a combo that uses the top-left tile of that block and has its type and flag
both set to "(None)." You should also modify the "MISC: Spawn" sprite in
Quest > Graphics > Sprites > Weapons/Misc. It needs to have the animation
speed and number of frames set; 3 frames at a speed of 5 will best match the
built-in enemies.

You'll have to set some constants in ghost.zh. Open it in a text editor. Use
a basic one like Notepad; more advanced word processors sometimes modify
punctuation marks, which can make scripts unusable. The constants look
similar to this:

const int CONSTANT_NAME = ###; // And sometimes there's a note here

The ### part is what you need to change; be sure to leave the equals sign and
semicolon in place. 

These are the standard settings:

GH_SHADOW_TILE
GH_SHADOW_CSET
GH_SHADOW_FRAMES
GH_SHADOW_ANIM_SPEED
GH_SHADOW_TRANSLUCENT
GH_SHADOW_FLICKER
   If a shadow needs to be drawn by the script, it will use these settings.
   If you want shadows to have multiple frames, they must be consecutive tiles,
   and GH_SHADOW_TILE should be the number of the first one. For the
   translucency and flickering settings, set the number to 1 (yes) or 0 (no).

GH_LARGE_SHADOW_TILE
GH_LARGE_SHADOW_CSET
GH_LARGE_SHADOW_FRAMES
GH_LARGE_SHADOW_ANIM_SPEED
   Large enemies may have 2x2 tile shadows using these settings. This only
   applies when built-in shadows are not used. This is the case only if
   GH_PREFER_GHOST_ZH_SHADOWS or GH_FAKE_Z are used or if a specific enemy
   uses fake Z movement. If GH_LARGE_SHADOW_TILE is 0, large shadows will not
   be used.

GH_LARGE_SHADOW_MIN_WIDTH
GH_LARGE_SHADOW_MIN_HEIGHT
   An enemy must be at least this large in tiles to have a large shadow.

GH_PREFER_GHOST_ZH_SHADOWS
   ghost.zh's shadows will be used instead of built-in ones whenever possible.

AUTOGHOST_MIN_FFC
AUTOGHOST_MAX_FFC
   Every scripted enemy uses at least one FFC. Set these to limit the range of
   FFCs they will use automatically. Use this if you want to reserve some FFCs
   for other purposes. Making this range too small can result in some scripts
   not working, so it's best not to restrict it more than necessary.
   
AUTOGHOST_MIN_ENEMY_ID
AUTOGHOST_MAX_ENEMY_ID
   AutoGhost enemies are identified by misc. attributes 11 and 12 being set.
   Other scripts may also use these settings; when multiple scripts use the
   same numbers for different purposes, they're likely to behave incorrectly.
   You can restrict the range of enemy IDs that will be used for AutoGhost
   enemies to avoid this.

GH_DRAW_OVER_THRESHOLD
   Some scripts set the FFC's "Draw Over" flag automatically as the enemy moves
   up and down. This determines the Z value at which it changes. This is similar
   to the setting "Jumping Sprite Layer Threshold" in the initialization data.
   
GH_GRAVITY
GH_TERMINAL_VELOCITY
   These should match the numbers set for gravity and terminal velocity in
   the initialization data. You'll probably never have any reason to change
   these two.

GH_SPAWN_SPRITE
   Scripted enemies don't use the normal spawn animations. This needs to be set
   so they can fake it. This is the number of the sprite used by spawning
   enemies, found in  Quest > Graphics > Sprites > Weapons/Misc. If you use the
   default sprite, 22, make sure its animation frames and speed are set.

GH_FAKE_Z
   If enabled, enemies won't move through the Z axis. Similar to unchecking the
   quest rule "Enemies Jump/Fly Through Z-Axis." Set this to 1 (yes) or 0 (no).

GH_ENEMIES_FLICKER
   If enabled, enemies will flicker instead of flashing. Similar to checking
   the quest rule "Enemies Flicker When Hit." Set this to 1 (yes) or 0 (no).

GH_BLANK_TILE
   You need to have a 4x4 block of blank tiles in the tile pages. Set this to
   the number of the tile in the top-left corner.

GH_INVISIBLE_COMBO
   The number of a combo with a blank tile and no type or flag set. The tile
   should also be the top-left of a 4x4 block of blank tiles.


If you're making multiple quests at once that use different settings, you
should use a different copy of ghost.zh for each one.


In ZQuest, go to Quest > Scripts > Compile ZScript... > Edit and enter this:

import "std.zh"
import "string.zh"
import "ghost.zh"

This assumes that all these files are in ZC's directory. If any of them
are in different directories, you'll have to specify that, for instance:
import "MyQuest\Scripts\ghost.zh"

Close the window, save the changes, and click Compile. In the Global tab,
load GhostZHActiveScript into the Active slot. In the Item tab, load
GhostZHClockScript into any slot.

If your quest uses clocks, set the clock's pickup script to GhostZHClockScript.
Set D0 to the same number as the clock's duration.



Individual enemies:


First, the script needs to be imported. In the script buffer, add another line
to import the file, for instance:
import "GoriyaLttP.z"

Some scripts may require that you import additional files, but don't include
any file more than once. Compile and load the FFC script into a slot.

Exactly what needs done varies from one enemy to the next, but a few things are
common. Most scripted enemies need at least one combo set up, but a few use the
invisible one. Every enemy needs its type (usually 'other'), HP, damage, tile,
CSet, and misc. attributes 11 and 12 set.

Misc. attributes 11 and 12 are used to identify the enemy as scripted and set
up an FFC to run the script. Attribute 11 indicates which combo the enemy
should use, and attribute 12 determines what script it runs. If either of these
is 0, the enemy will not be recognized as scripted and will not function.

Many enemies require more than one combo. In these cases, assume that all combos
must be consecutive in the list and attribute 11 set to the first one unless the
instructions say otherwise. Also, some scripts require that multiple enemies be
set up. Unless instructed otherwise, you only need to place the primary enemy on
the screen.

Some enemies use the invisible combo (GH_INVISIBLE_COMBO). In these cases, you
can set misc. attribute 11 to -1. A few enemies may also specify -2, another
special value.

Misc. attribute 12 can be set to the number of the script slot, or it can be set
to -1, indicating that the script name should be read from the enemy's name. If
you use -1, the script name must go in the enemy's name immediately following
the character @. The script name must appear exactly as shown after it is
compiled, including capitalization. It must be at the end of the enemy name or
followed by a space; any other character will cause it to be misread.

For example, using the Goriya_LttP script, these names will work:
  Goriya (LttP)   @Goriya_LttP
  Goriya @Goriya_LttP (L1)
  
These names will not work:
  Goriya (LttP)   @goriya_lttp
  Goriya (LttP)   @ Goriya_LttP
  Goriya (L1, @Goriya_LttP)

