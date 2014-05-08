package object
{
	import flash.geom.Point;
	
	import Component.ClickShoot;
	
	import entities.HUD;
	import entities.Player;
	import entities.Turret;
	
	import screens.Game;

	public class Store
	{
		
		public function Store()
		{
			
			
		}
		
		public function makeTurret(position:Point, type:int):Turret
		{
			Sounds.sndStorePurchase.play(0,0,Sounds.Transform);
			return new Turret(position,type, (type*400));
		}
		
		public function changeGun(type:int):void{
			Sounds.sndStorePurchase.play(0,0,Sounds.Transform);
			ClickShoot.type = type;
			switch(type){
				case 1:
					ClickShoot.accuracy = 30;
					Player.shootSpeed = .21;
					ClickShoot.range=1;
					ClickShoot.damage= 2;
					HUD.activeGun = 0;
					break;
				case 2:
					ClickShoot.accuracy = 50;
					Player.shootSpeed = .1;
					ClickShoot.range=1.4;
					ClickShoot.damage=2;
					HUD.activeGun = 1;
					break;
				case 3:
					ClickShoot.accuracy=0;
					Player.shootSpeed=.01;
					ClickShoot.range=1;
					ClickShoot.damage=2;
					HUD.activeGun = 3;
					break;
				case 4:
					ClickShoot.accuracy = 0;
					Player.shootSpeed = 1;
					ClickShoot.range=10;
					ClickShoot.damage=20;
					HUD.activeGun = 2;
					break;
			}
		}
	}
}