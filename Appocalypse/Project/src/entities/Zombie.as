package entities
{
	import flash.geom.Point;
	import flash.media.SoundTransform;
	
	import Component.Collidable;
	import Component.Component;
	import Component.Displayable;
	import Component.Drawing;
	import Component.Living;
	import Component.Movie;
	import Component.Pathing;
	import Component.Physics;
	import Component.Spatial;
	
	import events.CollisionEvent;
	
	import screens.Game;
	
	import starling.core.Starling;

	public class Zombie extends Entity
	{
		public static var zombies:Vector.<Zombie> = new Vector.<Zombie>();
		private var _type:int;
		private var _zombieIsHurt:Boolean = false;
		private var _zombieIsDead:Boolean = false;
		public function Zombie(spawnPoint:Point,path:Vector.<Point>, type:int = 1)
		{
			super();
			this.type = type;
			var life:Number = (type * 1.75) + 1;
			var speed:Number = (type * .1) + 1;
			if(speed > 3.5)
				speed = 3.5;
			if(type == -1)
			{
				speed = 3.5;
				life = 1;
				this.type = 100;
			}
			addComponent(new Displayable(this,null,"Z" + (this.type%5 +1) + "_DOWN_",5+(this.type%5+1)));
			addComponent(new Spatial(this,spawnPoint.x,spawnPoint.y,0,0,0));
			var height:Number = Displayable(getComponent("Displayable")).height;
			var width:Number = Displayable(getComponent("Displayable")).width;
			addComponent(new Movie(this));			
			var velX:Number = 400 - spawnPoint.x;
			var velY:Number = 300 - spawnPoint.y;
			var velVector:Point = new Point(velX,velY);
			addComponent(new Physics(this, velX/velVector.length * speed,velY/velVector.length * speed,speed));
			addComponent(new Collidable(this,hitSomething,1));
			addComponent(new Living(this,life));
			addComponent(new Pathing(this,path,new Point(Starling.current.stage.stageWidth/2,Starling.current.stage.stageHeight/2)));
			zombies.push(this);
		}
		
		public function get zombieIsDead():Boolean
		{
			return _zombieIsDead;
		}

		public function set zombieIsDead(value:Boolean):void
		{
			_zombieIsDead = value;
		}

		public function get zombieIsHurt():Boolean
		{
			return _zombieIsHurt;
		}

		public function set zombieIsHurt(value:Boolean):void
		{
			_zombieIsHurt = value;
		}

		public function hitByBullet():void
		{
			var life:Living = Living(getComponent("Living"));
			if(life != null && life.health > 0)
			{
				zombieIsHurt = true;
			}
			if(!life.alive)
			{
				Game.score += (5 * Math.ceil(type/2));
				dispose();
				zombieIsDead = true;
			}
		}
		
		private function hitSomething(e:CollisionEvent):void
		{
			var ent:Entity = Component(e.collison2).parent;
			var life:Living = Living(ent.getComponent("Living"));
			if(life!=null)
			{			
				if(life.health >= 0 && ent is Player)
				{
					Sounds.sndPlayerHurt.play(0,0,Sounds.Transform);
					life.health--;
				}
				if(!life.alive)
				{
					life.kill();
				}
				if(ent is Player)
				{
					dispose();
				}
				if(ent is Bullet)
				{
					var temp:Number = life.health;
					life.health -= Living(getComponent("Living")).health;
					Living(getComponent("Living")).health -= temp;
					if(life.health <=0)
					{
						ent.dispose();
						Game.score += temp * 2;
					}
					else
					{
						Game.score += (temp-life.health) * 2;
					}
					hitByBullet();						
				}
			}			
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

	}
}