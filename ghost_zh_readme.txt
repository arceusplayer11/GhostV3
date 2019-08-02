+----------------+
| INITIALIZATION |
+----------------+

void GhostInit(ffc this, npc ghost)
 * The basic initialization method. Provide your own npc.

npc GhostInitCreate(ffc this, int enemyID)
 * This will create the ghosted npc using the given ID and return a pointer to it.

npc GhostInitWait(ffc this, int enemyIndex, bool useEnemyPos)
 * Use this function if you want to use a normally placed enemy as the ghost.
 * enemyIndex is the npc's position in the screen's enemy list, which must be an integer between
 * 1 and 10. If useEnemyPos is true, the FFC will be moved to the enemy's position instead of the
 * other way around. The function will only wait 4 frames for the enemy to appear to minimize the
 * possibility of incorrectly using an enemy that is spawned by other means. The FFC will be made
 * invisible when the function is called, and will switch back to the original combo before it
 * returns.

npc GhostInitWait2(ffc this, int enemyID, int which, bool useEnemyPos)
 * Similar to GhostInitWait, except this loads the nth enemy of a given type. This is especially
 * helpful if enemies are present other than those placed normally, since you can't always be
 * certain what index an enemy will be assigned.

npc GhostInitSpawn(ffc this, int enemyID)
 * This will create the ghosted enemy in a random location.

void GhostInit(ffc this, npc ghost, int flags)
npc GhostInitCreate(ffc this, int enemyID, int flags)
npc GhostInitWait(ffc this, int enemyIndex, bool useEnemyPos, int flags)
npc GhostInitWait2(ffc this, int enemyID, int which, bool useEnemyPos, int flags)
npc GhostInitSpawn(ffc this, int enemyID, int flags)
 * These simply combine an Init method and SetFlags() into a single function call.

void SetFlags(ffc this, npc ghost, int flags)
 * Set flags that control the behavior of update functions. Use GHF constants ORed together for the
 * flags argument.
 *
 * GHF_KNOCKBACK: The enemy can be knocked back when hit.
 * GHF_STUN: Stunning will be handled automatically; Waitframe functions will not return while the
 *    enemy is stunned.
 * GHF_NO_FALL: ghost->Jump will be set to 0 each frame.
 * GHF_SET_DIRECTION: The npc's direction  will automatically be set based on which way it's moved.
 *    Recommended if GHF_KNOCKBACK is used.
 * GHF_SET_OVERLAY: Set the "Draw Over" flag each frame based on Z position. The height at which it
 *    changes is determined by GH_DRAW_OVER_THRESHOLD.
 * GHF_4WAY: Change the FFC's appearance based on the npc's direction. This must be used with
 *    GHF_SET_DIRECTION, and it requires a particular setup. You must have four consecutive combos
 *    in the list, one for each direction: up, down, left, and right, in order. The FFC should
 *    initially be set to use the first (upward-facing) combo. More precisely, whatever combo is
 *    shown when SetFlags() is called will be assumed to be the upward-facing one.
 * GHF_NORMAL: Combines GHF_KNOCKBACK, GHF_STUN, and GHF_SETDIRECTION.


+--------+
| UPDATE |
+--------+

bool GhostWaitframeN(ffc this, npc ghost, bool clearOnDeath, bool quitOnDeath)
bool GhostWaitframeF(ffc this, npc ghost, bool clearOnDeath, bool quitOnDeath)
bool GhostWaitframeM(ffc this, npc ghost, float x, float y, float z, bool clearOnDeath,
                     bool quitOnDeath)
 * These are replacement functions for Waitframe(). In addition to waiting a frame, they will handle
 * the necessary routine updates. These include matching the npc's and FFC's positions and dealing
 * with stunning, flashing, knockback, and death.
 * If clearOnDeath is true, when the npc dies, the FFC's combo will be set to 0 and the npc will be
 * moved so that its death animation and dropped item are centered.
 * If quitOnDeath is true, Quit() will be called when the npc dies; if false, the function will
 * return true if the npc is alive and false otherwise.
 *
 * These come in N, F, and M varieties, for "npc," "ffc," and "Manual," denoting how the enemy's
 * position is determined.
 * GhostWaitframeN() moves the FFC to the npc's position, which means coordinates are truncated
 * to integers.
 * GhostWaitframeF() moves the npc to the FFC's position. Coordinates are not truncated, and you can
 * rely on the FFC's velocity for movement. However, FFC positions have no Z value, so the enemy
 * will always be on the ground.
 * GhostWaitframeM() allows you to specify a position manually.
 *
 * If you want to make a custom Waitframe method that incorporates one of these, be aware that if
 * the enemy is stunned, the function won't return until it recovers or dies.

bool GhostWaitframesN(ffc this, npc ghost, bool clearOnDeath, bool quitOnDeath, int numFrames)
bool GhostWaitframesF(ffc this, npc ghost, bool clearOnDeath, bool quitOnDeath, int numFrames)
bool GhostWaitframesM(ffc this, npc ghost, float x, float y, float z, bool clearOnDeath,
                      bool quitOnDeath, int numFrames)
 * Call the corresponding Waitframe method numFrames times or until the npc dies.

void CheckHit(ffc this, npc ghost)
 * This will cause the enemy to flash and be knocked back when it is damaged.
 * Used internally by the Waitframe methods; if you use one of those, you don't need to use this.

bool CheckStun(ffc this, npc ghost)
 * Checks whether the npc has been stunned. If so, the function does not return until the npc either
 * recovers or dies. CheckHit() will be called each frame during that time. The return value is true
 * if the npc is still alive and false if it's dead.
 * Used internally by the Waitframe methods; if you use one of those, you don't need to use this.


+-------+
| OTHER |
+-------+

bool CanMove(ffc this, npc ghost, int dir, float step, int imprecision)
 * Determines whether the enemy can move in the given direction and distance. The imprecision
 * argument lets you ignore a couple of pixels at the edges so the enemy doesn't get stuck
 * on corners.

void Move(ffc this, npc ghost, float xStep, float yStep, int imprecision)
void MoveAtAngle(ffc this, npc ghost, float angle, float step, int imprecision)
void MoveTowardLink(ffc this, npc ghost, float step, int imprecision)
 * Makes the enemy move. CanMove() will be checked automatically. If the GHF_SETDIRECTION flag is
 * set, the npc's direction will be changed accordingly. If GHF_4WAY is also set, the FFC's combo
 * will be changed.

void Transform(ffc this, npc ghost, int combo, int cset, int tileWidth, int tileHeight)
 * Change the FFC to a new combo and CSet and resize the FFC and npc. The new width and height
 * are given in tiles and must be between 1 and 4. The FFC's and npc's positions will be adjusted
 * so that they're centered on the same spot. For all four numeric arguments, pass in -1 if you
 * don't want to change the existing value.
 * If you called SetOffsets() previously, it will be undone. The npc's size and position will be
 * set to match the FFC's.

void SwapGhost(npc oldGhost, npc newGhost, bool copyHP)
 * Copies size, position, Misc[], and optionally HP from the old ghost to the new one, then moves
 * the old one out of the way.

void ReplaceGhost(npc oldGhost, npc newGhost, bool copyHP)
 * Copies data from the old ghost to the new one, then silently kills the old one.

void SetOffsets(ffc this, npc ghost, float top, float bottom, float left, float right)
 * If you want the enemy's hitbox to be smaller than the FFC, use this function to adjust it. Each
 * argument will cause the hitbox to shrink away from the corresponding edge. Each argument can be
 * either an exact number of pixels or a fraction of the FFC's full size. So, for instance, a top
 * argument of 0.25 would shrink hitbox by 1/4 of the FFC's height.

void Set4WayCombo(ffc this, npc ghost, int newCombo)
 * If GH_4WAY is set, use this function to change to a different set of combos. Pass in the upward-
 * facing combo for the newCombo argument, regardless of which way the enemy is facing.

void SetHP(ffc this, npc ghost, int newHP)
 * Changes the npc's HP. Setting ghost->HP directly will interfere with flashing, so use this 
 * function instead.

void SetAllDefenses(npc ghost, int defType)
 * Set all of the enemy's defenses to the given type.

bool GotHit(ffc this)
 * Returns true if the enemy was hit in the last frame.

npc SpawnNPC(int id)
 * Spawns an npc with the given ID in a random location. This will avoid solid combos, pits, water,
 * "no enemy" combos and flags, Link, and screen edges on NES dungeon screens. The spawn location is
 * undefined if no suitable location exists, but that will not happen unless there is almost no
 * space available on the screen.


+----------+
| EWEAPONS |
+----------+

eweapon FireEWeapon(int weaponID, int x, int y, float angle, int step, int damage, int sprite,
                    int sound, int flags)
 * Create an eweapon with the given properties. The angle is given in radians. The sprite argument
 * should be the ID of a sprite from Quest > Graphics > Sprites > Weapons/Misc. The default sprite
 * will be used if this argument is -1. If you don't want any sound to be played, pass in 0 for that
 * argument. The flags argument should be one or more EWF constants ORed together, or 0 for none.
 *
 * EWF_UNBLOCKABLE: The weapon is unblockable.
 * EWF_ROTATE: The weapon's sprite will be rotated and flipped according to the weapon's direction. 
 * EWF_SHADOW: The weapon will cast a shadow if it's Z is greater than 0.
 * EWF_FLICKER: The weapon will be invisible every other frame.

eweapon FireAimedEWeapon(int weaponID, int x, int y, float angle, int step, int damage, int sprite,
                         int sound, int flags)
 * Fire a projectile aimed at Link. The angle argument is an offset, so an angle of 0.2, say, will
 * aim slightly away from Link no matter where he is.

eweapon FireNonAngularEWeapon(int weaponID, int x, int y, int direction, int step, int damage,
                              int sprite, int sound, int flags)
 * Use this to fire non-angular projectiles. EWF_UNBLOCKABLE can't be used with this function,
 * because a weapon is made unblockable by changing its direction.

eweapon FireBigEWeapon(int weaponID, int x, int y, float angle, int step, int damage, int sprite,
                       int sound, int flags, int width, int height)
eweapon FireBigAimedEWeapon(int weaponID, int x, int y, float angle, int step, int damage,
                            int sprite, int sound, int flags, int width, int height)
eweapon FireBigNonAngularEWeapon(int weaponID, int x, int y, int direction, int step, int damage,
                                 int sprite, int sound, int flags, int width, int height)
 * These are the same as the three above, except they also allow you to set the eweapon's size.
 * The width and height are given in tiles.

void SetEWeaponMovement(eweapon wpn, int type, int arg)
 * This sets an eweapon's movement pattern. The type argument should be one of the EWM constants.
 * The second argument's effect varies depending on the type of movement.
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
 *    arg: Initial upward velocity
 * EWM_FALL: Fall straight down. The weapon dies when it hits the ground.
 *    arg: Initial height

void SetEWeaponLifespan(eweapon wpn, int type, int arg)
 * This controls the conditions under which a weapon dies. "Dying" does not mean the weapon is
 * removed, but that its scripted movement is no longer handled, and, optionally, a death effect is
 * activated. Use one of the EWL constants for the type argument.
 * 
 * EWL_TIMER: Die after a certain amount of time.
 *    arg: Time, in frames
 * EWL_NEAR_LINK: Die when within a certain distance of Link.
 *    arg: Distance, in pixels
 * EWL_SLOW_TO_HALT: Slow down until stopped, then die. This behaves oddly with some movement types.
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
 * EWD_4_FIREBALLS_RANDOM: Randomly shoots fireballs either vertically and horizontally or at
 *    45-degree angles.
 *    arg: Fireball sprite
 * EWD_8_FIREBALLS: Shoots fireballs horizontally, vertically, and at 45-degree angles
 *    arg: Fireball sprite
 * EWD_4_FIRES_HV: Shoots fires horizontally and vertically.
 *    arg: Fire sprite
 * EWD_4_FIRES_DIAG: Shoots fires at 45-degree angles.
 *    arg: Fire sprite
 * EWD_4_FIRES_RANDOM: Randomly shoots fires either vertically and horizontally or at
 *    45-degree angles.
 *    arg: Fire sprite
 * EWD_8_FIRES: Shoots fires horizontally, vertically, and at 45-degree angles
 *    arg: Fire sprite
 * EWD_SPAWN_NPC: Creates an npc at the weapon's location. This is done without regard for the
 *    suitability of the location.
 *    arg: npc to spawn

void UpdateEWeapon(eweapon wpn)
 * If an eweapon uses any of the special features provided by the functions above, including flags,
 * this function must be called each frame to enable them.

void UpdateEWeapons()
 * Calls UpdateEWeapon on each eweapon.

void SetEWeaponDir(eweapon wpn)
 * Set the direction of an angled eweapon so that it interacts correctly with shields. This should
 * not be used on unblockable weapons.

void SetEWeaponRotation(eweapon wpn)
void SetEWeaponRotation(eweapon wpn, int direction)
 * Rotate the weapon's sprite. If the direction argument is not given, this is done according to the
 * weapon's direction.

void KillEWeapon(eweapon wpn)
 * Kill the eweapon, stopping scripted movement and activating any death effects.

void DrawEWeaponShadow(eweapon wpn)
 * Draws a shadow under the eweapon according to the GH_SHADOW constants. This is used internally
 * when EWF_SHADOW is set.

