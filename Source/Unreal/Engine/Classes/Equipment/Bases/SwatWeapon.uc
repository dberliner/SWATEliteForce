class SwatWeapon extends FiredWeapon;

/*
 * Describes which "equip type" a weapon is a part of.
 * This is pretty self-explanatory.
 */
enum WeaponEquipType
{
  WeaponEquip_PrimaryOnly,
  WeaponEquip_SecondaryOnly,
  WeaponEquip_Either
};

/*
 * Describes which "equip class" a weapon is a part of.
 * This determines the category of weapon for the GUI, nothing more.
 * If a class has no valid weapons for the slot, the category won't appear.
 */
enum WeaponEquipClass
{
  WeaponClass_AssaultRifle,             // Assault Rifles (M4, M16, AKM, etc.)
  WeaponClass_MarksmanRifle,            // Marksman Rifles (scoped rifles)
  WeaponClass_SubmachineGun,            // Submachine Guns (MP5, G36C, Uzi, etc.)
  WeaponClass_Shotgun,                  // Shotguns (M4, Nova, M870, BSG)
  WeaponClass_LightMachineGun,          // Light Machine Guns (M249 SAW)
  WeaponClass_MachinePistol,            // Machine Pistols; SMGs that don't have a stock (MP5K, TEC-9)
  WeaponClass_Pistol,                   // Pistols (Desert Eagle, M1911, Glock, ... but not tasers!)
  WeaponClass_LessLethal,               // Less-lethal shotguns, tasers, and pepperball
  WeaponClass_GrenadeLauncher,          // Grenade Launchers (ARWEN 37, HK69)
  WeaponClass_Uncategorized             // Not categorized! Find one!
};

/*
 * Determines what animation set the weapon should use while equipped.
 */
enum WeaponAimAnimationType
{
  WeaponAnimAim_Handgun,
  WeaponAnimAim_SubmachineGun,
  WeaponAnimAim_MachineGun,
  WeaponAnimAim_Shotgun,
  WeaponAnimAim_Grenade,
  WeaponAnimAim_TacticalAid,
  WeaponAnimAim_TacticalAidUse,
  WeaponAnimAim_PepperSpray,
  WeaponAnimAim_M4,
  WeaponAnimAim_UMP,
  WeaponAnimAim_P90,
  WeaponAnimAim_Optiwand,
  WeaponAnimAim_Paintball,
  WeaponAnimAim_Cuffed
};

enum WeaponLowReadyAnimationType
{
  WeaponAnimLowReady_Handgun,
  WeaponAnimLowReady_SubmachineGun,
  WeaponAnimLowReady_MachineGun,
  WeaponAnimLowReady_Shotgun,
  WeaponAnimLowReady_Grenade,
  WeaponAnimLowReady_TacticalAid,
  WeaponAnimLowReady_PepperSpray,
  WeaponAnimLowReady_M4,
  WeaponAnimLowReady_UMP,
  WeaponAnimLowReady_P90,
  WeaponAnimLowReady_Optiwand,
  WeaponAnimLowReady_Paintball
};

enum EIdleWeaponStatus
{
	IdleWeaponDoesNotMatter,
  IdleWithSAW,
  IdleWithMachineGun,
	IdleWithG36,
	IdleWithSubMachineGun,
	IdleWithUMP,
  IdleWithHandgun,
	IdleWithShotgun,
	IdleWithPaintballGun,
	IdleWithGrenade,
  IdleWithP90,
	IdleWithAnyWeapon,
  IdleWithoutWeapon
};

var(Firing) config int MagazineSize;
var(Firing) protected config float Choke "Mostly used for shotguns - specifies how spread apart bullets should be - applied after AimError";
var(Firing) config WeaponAimAnimationType AimAnimation;
var(Firing) config WeaponLowReadyAnimationType LowReadyAnimation;
var(Firing) config array<EIdleWeaponStatus> IdleWeaponCategory;

// Manufacturer Information
var(AdvancedDescription) protected localized config string Manufacturer         "The Manufacturer in the Advanced Information panel (localized)";
var(AdvancedDescription) protected localized config string CountryOfOrigin      "The Country of Origin in the Advanced Information panel (localized)";
var(AdvancedDescription) protected localized config string ProductionStart      "The Production Start in the Advanced Information panel (localized)";
// Cartridge Information
var(AdvancedDescription) protected localized config string Caliber              "The Caliber in the Advanced Information panel (localized)";
var(AdvancedDescription) protected localized config string MagazineSizeString   "The Magazine Size in the Advanced Information panel - this needs to be defined separately since real magazine size is determined by ammo. Logical, right?";
var(AdvancedDescription) protected localized config string TotalAmmoString      "The Total Ammo in the Advanced Information panel - human friendly localized string";
// Action Information
var(AdvancedDescription) protected localized config string FireModes            "Human-readable firing mode string for Advanced Information panel (localized)";
// Muzzle velocity
var(AdvancedDescription) protected localized config string RateOfFire           "Human-readable RoF string for Advanced Information panel (localized)";

var(Categorization) public config WeaponEquipClass WeaponCategory            "Which category this weapon belongs to in the GUI.";
var(Categorization) public config WeaponEquipType AllowedSlots               "Which slots this weapon is allowed to be equipped in";

// Weight/bulk
var() public config float Weight;
var() public config float Bulk;

var bool bPenetratesDoors;

simulated function float GetWeight() {
  return Weight;
}

simulated function float GetBulk() {
  return Bulk;
}

simulated function float GetChoke()
{
  return Choke;
}

simulated function UpdateAmmoDisplay()
{
  Ammo.UpdateHUD();
}

static function string GetManufacturer()
{
    return "Manufacturer: "$default.Manufacturer;
}

static function string GetCaliber()
{
  return "Caliber: "$default.Caliber;
}

static function string GetCountryOfOrigin()
{
  return "Country of Origin: "$default.CountryOfOrigin;
}

static function string GetMagSize()
{
  if(default.MagazineSize != 0) {
    return "Magazine Size: "$string(default.MagazineSize);
  }
  return "Magazine Size: "$default.MagazineSizeString;
}

static function string GetProductionStart()
{
  return "Started Production: "$default.ProductionStart;
}

static function string GetFireModes()
{
  return "Fire Modes: "$default.FireModes;
}

static function string GetMuzzleVelocityString()
{
  // AK-47 has muzzle velocity (ingame) of 47,404 units and this is confirmed accurate
  // In reality it fires at 715 m/s (2,350 ft/s)
  // Therefore by multiplying by ~0.015 you can get meters and 0.05 for feet
  local int metersPerSecond, feetPerSecond;
  local string metersPerSecondStr, feetPerSecondStr;
  metersPerSecond = default.MuzzleVelocity / 50.4725;
  feetPerSecond = default.MuzzleVelocity / 15.385;
  metersPerSecondStr = string(metersPerSecond);
  feetPerSecondStr = string(feetPerSecond);

  return "Muzzle Velocity: "$feetPerSecondStr$" ft/s ("$metersPerSecondStr$" m/s)";
}

static function string GetRateOfFire()
{
  return "Rate of Fire: "$default.RateOfFire;
}

static function string GetTotalAmmoString()
{
  return "Maximum Ammo: "$default.TotalAmmoString;
}

simulated function bool HandleDoorImpact(
    Actor Victim,
    vector HitLocation,
    vector HitNormal,
    Material HitMaterial,
    vector ExitLocation,
    vector ExitNormal,
    Material ExitMaterial
    )
{
	Ammo.SetLocation(HitLocation);
	Ammo.SetRotation(rotator(HitNormal));
	Ammo.TriggerEffectEvent('BulletHit', None, HitMaterial);

	Ammo.SetLocation( ExitLocation );
    Ammo.SetRotation( rotator(ExitNormal) );
    Ammo.TriggerEffectEvent('BulletExited', Victim, ExitMaterial);
	return bPenetratesDoors;
}

static function WeaponEquipClass GetEquipClass()
{
  return default.WeaponCategory;
}

static function WeaponEquipType GetEquipType()
{
  return default.AllowedSlots;
}

function WeaponAimAnimationType GetAimAnimation()
{
  return AimAnimation;
}

function WeaponLowReadyAnimationType GetLowReadyAnimation()
{
  return LowReadyAnimation;
}

function bool ValidIdleCategory(EIdleWeaponStatus DesiredStatus)
{
  local int i;

  for(i = 0; i < IdleWeaponCategory.Length; i++)
  {
    if(IdleWeaponCategory[i] == DesiredStatus)
    {
      return true;
    }
  }
  return false; // This isn't a valid idle category for this weapon
}

//simulated function UnEquippedHook();  //TMC do we want to blank the HUD's ammo count?

defaultproperties
{
  Manufacturer="Unknown"
  Caliber="Unknown"
  CountryOfOrigin="Unknown"
  MagazineSize=0
  ProductionStart="Unknown"
  FireModes="Unknown"
  MagazineSizeString="Unknown"
  RateOfFireString="Not Applicable"
  TotalAmmoString="Unknown"
  Choke = 0.0
  Slot=Slot_Invalid
  bPenetratesDoors=true
}
