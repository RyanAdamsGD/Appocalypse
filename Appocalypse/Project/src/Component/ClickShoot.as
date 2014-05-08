package Component
{
	import flash.geom.Point;
	
	import entities.Bullet;
	import entities.Entity;
	
	import screens.Game;
	
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ClickShoot extends Component
	{
		public static var bullets:Vector.<Bullet> = new Vector.<Bullet>();
		private var timeBetweenBullets:Number = .2;
		public static var accuracy:int = 30;
		public static var range:Number =1;
		public static var damage:Number=2;
		public static var type:int = 0;
		
		private var _timeSinceLastBullet:Number;
		private var stage:Stage;
		private var lastTarget:Point;
		private var keepShooting:Boolean;
		public function ClickShoot(parent:Entity,timeBetweenBullets:Number = .2)
		{
			super("ClickShoot", parent);
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, onTouch);
			Starling.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.stage = Starling.current.stage;
			this.timeBetweenBullets = timeBetweenBullets;
			
			timeSinceLastBullet = 0;
			keepShooting = false;
		}
		
		private function onEnterFrame():void
		{			
			if(Game.time == Game.DAY_TIME)
				keepShooting = false;
			
			if(keepShooting)
				fire(lastTarget);
			
		}

		private function onTouch(e:TouchEvent):void
		{
			var target:Point = new Point();
			if(e.touches[0].phase == TouchPhase.BEGAN)
			{
				e.touches[0].getLocation(Starling.current.stage, target);
				lastTarget = target;
				keepShooting = true;
			}
			if(e.touches[0].phase == TouchPhase.MOVED || e.touches[0].phase == TouchPhase.STATIONARY)
			{
				e.touches[0].getLocation(Starling.current.stage, target);
				lastTarget = target;
			}
			if(e.touches[0].phase == TouchPhase.ENDED)
			{
				keepShooting=false;
			}
		}
		public override function cleanUp():void
		{
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		private function fire(target:Point):void
		{
			if(timeSinceLastBullet > timeBetweenBullets)
			{
				timeSinceLastBullet = 0;
				if(ClickShoot.type == 0)
					Sounds.sndGunshot.play(0,0,Sounds.Transform);
				if(ClickShoot.type == 2)
					Sounds.sndM16Firing.play(0,0,Sounds.Transform);
				if(ClickShoot.type == 3)
					Sounds.sndGrenadeExplodes.play(0,0,Sounds.Transform);
				if(ClickShoot.type == 4)
					Sounds.sndSniperShot.play(0,0,Sounds.Transform);
				makeBullet(new Point(target.x + Game.screenToWorldX, target.y + Game.screenToWorldY) ,new Point(Starling.current.stage.stageWidth/2 + 20 + Game.screenToWorldX, Starling.current.stage.stageHeight/2+30 + Game.screenToWorldY));
			}
		}
		private function makeBullet(target:Point, source:Point):void
		{
			if(Math.random() > .5)
			{
				target.x += Math.random() * accuracy;
			}
			else
			{
				target.x -= Math.random() * accuracy;
			}
			if(Math.random() > .5)
			{
				target.y += Math.random() * accuracy;
			}
			else
			{
				target.y -= Math.random() * accuracy;
			}
			var bullet:Bullet = new Bullet(target,source,type, range, damage + Math.floor(Game.level/5));
			bullets.push(bullet);
		}
		
		public function update(dt:Number):void
		{
			timeSinceLastBullet += dt;
		}

		public function get timeSinceLastBullet():Number
		{
			return _timeSinceLastBullet;
		}

		public function set timeSinceLastBullet(value:Number):void
		{
			_timeSinceLastBullet = value;
		}

	}
}