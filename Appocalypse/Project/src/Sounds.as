package
{	
	import flash.media.Sound;
	import flash.media.SoundTransform;

	public class Sounds
	{	
		[Embed(source="../../Sounds/hurt.mp3")]
		public static const PlayerIsHurt:Class;
		
		[Embed(source="../../Sounds/EnragedZombies.mp3")]
		public static const EnargedZombies:Class;
		
		[Embed(source="../../Sounds/startingpistol.mp3")]
		public static const PlayerPistol:Class;
		
		[Embed(source="../../Sounds/ZombieHorde.mp3")]
		public static const ZombieHorde:Class;
		
		[Embed(source="../../Sounds/ZombieMoan.mp3")]
		public static const ZombieMoan:Class;
		
		[Embed(source="../../Sounds/ManScream.mp3")]
		public static const PlayerIsKilled:Class;
		
		[Embed(source="../../Sounds/TurretShots.mp3")]
		public static const TurretShooting:Class;
		
		[Embed(source="../../Sounds/TheTower.mp3")]
		public static const AlternateBGMusic:Class;
		
		[Embed(source="../../Sounds/NoAmmo.mp3")]
		public static const GunIsEmpty:Class;
		
		[Embed(source="../../Sounds/Reload.mp3")]
		public static const GunIsReloaded:Class;
		
		[Embed(source="../../Sounds/SniperRifleShot.mp3")]
		public static const SniperRifleIsFired:Class;
		
		[Embed(source="../../Sounds/Grenade.mp3")]
		public static const GrenadeLauncherIsUsed:Class;
		
		[Embed(source="../../Sounds/BoughtANewItem.mp3")]
		public static const StorePurchase:Class;
		
		[Embed(source="../../Sounds/ZombieDeath.mp3")]
		public static const ZombieDeath:Class;
		
		[Embed(source="../../Sounds/AutomaticRifleShot.mp3")]
		public static const M16GunShot:Class;
		
		[Embed(source="../../Sounds/DrinkingWater.mp3")]
		public static const DrinkWater:Class;
		
		//BGM
		public static var sndAlternateMusic:Sound = new Sounds.AlternateBGMusic() as Sound;
		
		//Player Sounds
		public static var sndPlayerHurt:Sound = new Sounds.PlayerIsHurt() as Sound;
		public static var sndPlayerKilled:Sound = new Sounds.PlayerIsKilled() as Sound;
		
		//Zombie Noises
		public static var sndZombiesEnraged:Sound = new Sounds.EnargedZombies() as Sound;
		public static var sndZombieHorde:Sound = new Sounds.ZombieHorde() as Sound;
		public static var sndZombieMoan:Sound = new Sounds.ZombieMoan() as Sound;
		public static var sndZombieDeath:Sound = new Sounds.ZombieDeath() as Sound;
		
		//Gun/Turret Sound effects
		public static var sndGunshot:Sound = new Sounds.PlayerPistol() as Sound;
		public static var sndTurretShooting:Sound = new Sounds.TurretShooting() as Sound;
		public static var sndGunHasNoAmmunition:Sound = new Sounds.GunIsEmpty() as Sound;
		public static var sndGunIsBeingReloaded:Sound = new Sounds.GunIsReloaded() as Sound;
		public static var sndSniperShot:Sound = new Sounds.SniperRifleIsFired() as Sound;
		public static var sndGrenadeExplodes:Sound = new Sounds.GrenadeLauncherIsUsed() as Sound;
		public static var sndM16Firing:Sound = new Sounds.M16GunShot() as Sound;
		
		//Miscellaneous
		public static var sndStorePurchase:Sound = new Sounds.StorePurchase() as Sound;
		public static var sndDrinkingWater:Sound = new Sounds.DrinkWater() as Sound;
		
		private static var _volume:Number = 0.1;
		public static var Transform:SoundTransform = new SoundTransform(volume);
		public static var muted:Boolean = false;

		public static function get volume():Number
		{
			return _volume;
		}

		public static function set volume(value:Number):void
		{
			_volume = value;
			Transform = new SoundTransform(volume);
		}

	}
}