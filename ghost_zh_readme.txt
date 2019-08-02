+-------+
| SETUP |
+-------+

Use one of the four Init methods at the start of a script to set up the enemy and FFC. They will match the FFC's and the
enemy's sizes and positions and store some data for later use. After initialization, you can set flags to adjust later
behavior.


void GhostInit(ffc this, npc ghost)
 * The basic initialization method. Provide your own NPC.

npc GhostInitCreate(ffc this, int enemyID)
 * This will create the ghosted NPC using the given ID and return a pointer to it.

npc GhostInitWait(ffc this, int enemyIndex, bool useEnemyPos)
 * Use this function if you want to use a normally placed enemy as the ghost. enemyIndex is its position in the list,
 * which must be an integer between 1 and 10. If useEnemyPos is true, the FFC will be moved to the enemy's position
 * instead of the other way around. The function will only wait 4 frames for the enemy to appear to minimize the
 * possibility of incorrectly using an enemy that is spawned by other means. The FFC will be made invisible when the
 * function is called, and will switch back to the original combo before it returns.

npc GhostInitWait2(ffc this, int enemyID, int which, bool useEnemyPos)
 * Similar to GhostInitWait, except this loads the nth enemy of a given type. This is especially helpful if enemies
 * are present other than those placed normally, since you can't always be certain what index an enemy will be assigned.

npc GhostInitSpawn(ffc this, int enemyID)
 * This will create the ghosted enemy in a random location.

void SetFlags(ffc this, int flags)
 * Set flags that control the behavior of update functions. Use GHF constants ORed together for the flags argument.
 *
 * GHF_KNOCKBACK: The enemy can be knocked back when hit.
 * GHF_STUN: Stunning will be handled automatically; Waitframe functions will not return while the enemy is stunned.
 * GHF_NO_FALL: ghost->Jump will be set to 0 each frame.
 * GHF_SET_DIRECTION: The NPC's direction  will automatically be set based on which way it's moved. Recommended if
 *    GHF_KNOCKBACK is used.
 * GHF_SET_OVERLAY: Set the "Draw Over" flag each frame based on Z position. The height at which it changes is
 *    determined by GH_DRAW_OVER_THRESHOLD.
 * GHF_NORMAL: Combines GHF_KNOCKBACK, GHF_STUN, and GHF_SETDIRECTION.


+------------+
| WAITFRAMES |
+------------+

bool GhostWaitframeN(ffc this, npc ghost, bool clearOnDeath, bool quitOnDeath)
bool GhostWaitframeF(ffc this, npc ghost, bool clearOnDeath, bool quitOnDeath)
bool GhostWaitframeM(ffc this, npc ghost, float x, float y, float z, bool clearOnDeath, bool quitOnDeath)
 * These are replacement functions for Waitframe(). In addition to waiting a frame, they will handle the necessary routine
 * updates. These include matching the NPC's and FFC's positions, handling stunning, flashing, and knockback, and handling
 * death. If clearOnDeath is true, when the NPC dies, the FFC's combo will be set to 0 and the NPC will be moved so that its
 * death animation and dropped item are centered. If quitOnDeath is true, Quit() will be called when the NPC dies; if false,
 * the function will return true if the NPC is alive and false otherwise.
 *
 * These come in N, F, and M varieties, for "NPC," "FFC," and "Manual," denoting how the enemy's position is determined.
 * GhostWaitframeN() moves the FFC to the NPC's position, which means coordinates are truncated to integers.
 * GhostWaitframeF() moves the NPC to the FFC's position. Coordinates are not truncated, and you can rely on the FFC's velocity
 * for movement. However, FFC positions have no Z value, so the enemy will always be on the ground.
 * GhostWaitframeM() allows you to specify a position manually.
 *
 * If you want to make a custom Waitframe method that incorporates one of these, be aware that if the enemy is stunned, the
 * function won't return until it recovers or dies.

bool GhostWaitframesN(ffc this, npc ghost, bool clearOnDeath, bool quitOnDeath, int numFrames)
bool GhostWaitframesF(ffc this, npc ghost, bool clearOnDeath, bool quitOnDeath, int numFrames)
bool GhostWaitframesM(ffc this, npc ghost, float x, float y, float z, bool clearOnDeath, bool quitOnDeath, int numFrames)
 * Call the corresponding Waitframe method numFrames times or until the NPC dies.
 

+--------+
| UPDATE |
+--------+

These functions are used internally by the Waitframe replacements, but are available to use if you'd rather write your own.

void CheckHit(ffc this, npc ghost)
 * This makes the FFC react when the enemy is damaged. It will cause the FFC to flash and be knocked back. This will not handle
 * stunning, only damage.

bool CheckStun(ffc this, npc ghost)
 * Checks whether the NPC has been stunned. If so, the function does not return until the NPC either recovers or dies.
 * CheckHit() will be called each frame during that time. The return value is true if the NPC is still alive and false if it's
 * dead.


+-----------------------+
| OTHER GHOST FUNCTIONS |
+-----------------------+

bool GotHit(ffc this)
 * Returns true if the enemy was hit in the last frame.

bool CanMove(ffc this, npc ghost, int dir, float step, int imprecision)
 * Determines whether the enemy can move in the given direction and distance. The imprecision argument lets you ignore a couple
 * of pixels at the edges so the enemy doesn't get stuck on corners.

void Move(ffc this, npc ghost, float xStep, float yStep, int imprecision)
 * Makes the enemy move, if it's able.

void Transform(ffc this, npc ghost, int combo, int cset, int tileWidth, int tileHeight)
 * Change the FFC to a new combo and CSet and resize the FFC and NPC. The new width and height are given in tiles and must be
 * between 1 and 4. The FFC's and NPC's positions will be adjusted so that they're centered on the same spot. For all four
 * numeric arguments, pass in -1 if you don't want to change the existing value.

void SwapGhost(npc oldGhost, npc newGhost, bool copyHP)
 * Copies necessary data, optionally including HP, from the old ghost to the new one, then moves the old one out of the way.

void ReplaceGhost(npc oldGhost, npc newGhost, bool copyHP)
 * Copies data from the old ghost to the new one, then silently kills the old one.

void SetHP(ffc this, npc ghost, int newHP)
 * Changes the NPC's HP without interfering with the enemy's flashing.


+----------+
| EWEAPONS |
+----------+

eweapon FireEWeapon(int weaponID, int x, int y, float angle, int step, int damage, bool blockable, int sprite, bool rotate, int sound)
 * Create an eweapon with the given properties. The angle is given in radians. The sprite argument should be the ID of a sprite
 * from Quest > Graphics > Sprites > Weapons/Misc. The default sprite will be used if this argument is -1. If the rotate
 * argument is true, the sprite will be rotated and flipped according to the weapon's direction. If you don't want any sound to
 * be played, pass in 0 for that argument.
 * If the global function UpdateEWeapons() is not used, the blockable argument should always be true.

eweapon FireAimedEWeapon(int weaponID, int x, int y, float angle, int step, int damage, bool blockable, int sprite, bool rotate, int sound)
 * Fire a projectile aimed at Link. The angle argument is an offset, so an angle of 0.2, say, will aim slightly away from Link
 * no matter where he is.

eweapon FireNonAngularEWeapon(int weaponID, int x, int y, int direction, int step, int damage, int sprite, bool rotate, int sound)
 * Use this to fire non-angular projectiles.

void SetEWeaponMovement(eweapon wpn, int type, int arg)
 * Used with the global function UpdateEWeapons(), this sets an eweapon's movement pattern. The type argument should be one of
 * the EWM constants. The second argument's effect varies depending on the type of movement.
 *
 * EWM_SINE_WAVE: Move in a sine wave.
 *    arg: Amplitude
 * EWM_SINE_WAVE_FAST: Move in a sine wave with a shorter wavelength.
 *    arg: Amplitude
 * EWM_HOMING: Turn toward Link each frame.
 *    arg: Maximum rotation per frame in radians
 * EWM_HOMING_REAIM: Move in straight lines, stopping and re-aiming at Link.
 *   arg: Number of re-aims
 * EWM_RANDOM: Turn randomly each frame.
 *   arg: Maximum rotation per frame in radians
 * EWM_RANDOM_REAIM: Stop frequently and aim in a random direction
 *    arg: Number of re-aims
 * EWM_VEER_UP: Accelerate upward.
 *    arg: Acceleration
 * EWM_VEER_DOWN: Accelerate downward.
 *    arg: Acceleration
 * EWM_VEER_LEFT: Accelerate left.
 *    arg: Acceleration
 * EWM_VEER_RIGHT: Accelerate right.
 *    arg: Acceleration
 * EWM_THROW: Arc through the air. The weapon dies (see below) when it hits the ground.
 *    arg: Initial upward velocity; if this is 0, the velocity will automatically be set so the weapon travels the necessary distance
 *         to reach Link

void SetEWeaponLifespan(eweapon wpn, int type, int arg)
 * This controls the conditions under which a weapon dies. Dying does not mean the weapon is removed, but that its scripted
 * movement is no longer handled and and, optionally, a death effect is activated. Use the EWL constants for the type argument.
 * 
 * EWL_TIMER: Die after a certain amount of time.
 *    arg: Timer
 * EWL_NEAR_LINK: Die when within a certain distance of Link.
 *    arg: Distance
 * EWL_SLOW_TO_HALT: Slow down until stopped, then die. This may behave oddly with some movement types.
 *    arg: Step per frame

void SetEWeaponDeathEffect(eweapon wpn, int type, int arg)
 * This determines what happens when the weapon dies. Use the EWD constants for the type argument.
 *
 * EWD_VANISH: The weapon is removed.
 *    arg: No effect
 * EWD_AIM_AT_LINK: The weapon pauses for a moment, then aims at Link.
 *    arg: Delay
 * EWD_EXPLODE: The weapon explodes.
 *    arg: Explosion damage
 * EWD_SBOMB_EXPLODE: The weapon explodes like a super bomb.
 *    arg: Explosion damage
 * EWD_4_FIREBALLS_HV: Shoots fireballs horizontally and vertically.
 *    arg: Fireball sprite
 * EWD_4_FIREBALLS_DIAG: Shoots fireballs at 45-degree angles.
 *    arg: Fireball sprite
 * EWD_4_FIREBALLS_RANDOM: Randomly shoots fireballs either vertically and horizontally or at 45-degree angles.
 *    arg: Fireball sprite
 * EWD_8_FIREBALLS: Shoots fireballs horizontally, vertically, and at 45-degree angles
 *    arg: Fireball sprite
 * EWD_4_FIRES_HV: Shoots fires horizontally and vertically.
 *    arg: Fire sprite
 * EWD_4_FIRES_DIAG: Shoots fires at 45-degree angles.
 *    arg: Fire sprite
 * EWD_4_FIRES_RANDOM: Randomly shoots fires either vertically and horizontally or at 45-degree angles.
 *    arg: Fire sprite
 * EWD_8_FIRES: Shoots fires horizontally, vertically, and at 45-degree angles
 *    arg: Fire sprite
 * EWD_SPAWN_NPC: Creates an NPC at the weapon's location. This is done without regard for the suitability of the location.
 *    arg: NPC to spawn

void UpdateEWeapons()
 * This function enables unblockable eweapons and the complex behaviors set by the three functions above. It should be called by
 * the global script every frame before Waitdraw().

void SetEWeaponDir(eweapon wpn)
 * Set the direction of an angled eweapon so that it interacts correctly with shields. This should not be used on unblockable
 * weapons.

void SetEWeaponRotation(eweapon wpn)
void SetEWeaponRotation(eweapon wpn, int direction)
 * Rotate the weapon's sprite. If the direction argument is not given, this is done according to the weapon's direction.


+-----------+
| UTILITIES |
+-----------+

npc SpawnNPC(int id)
 * Spawns an NPC with the given ID in a random location. This will avoid solid combos, pits, water, "no enemy" combos
 * and flags, Link, and screen edges on NES dungeon screens. The spawn location is undefined if no suitable location
 * exists, but that will not happen unless there is almost no space available on the screen.

bool IsWater(int position)
 * Returns true if the combo at the given location is water, a swim warp, or a dive warp.

bool IsPit(int position)
 * Returns true if the combo at the given location is a direct warp.

float CenterX(ffc anFFC)
float CenterY(ffc anFFC)
int CenterX(npc anNPC)
int CenterY(npc anNPC)
int CenterX(eweapon anEWeapon)
int CenterY(eweapon anEWeapon)
int CenterX(lweapon anLWeapon)
int CenterY(lweapon anLWeapon)
int CenterLinkX()
int CenterLinkY()
 * These return the X or Y position at the center of an object. Helpful if you don't want to aim objects of different sizes from
 * their top-left corners.
