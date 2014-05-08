package entities
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import Component.Collidable;
	import Component.Component;
	import Component.Displayable;
	import Component.Drawing;
	import Component.Living;
	import Component.Physics;
	import Component.Spatial;
	
	import events.CollisionEvent;
	
	import screens.Game;

	public class Bullet extends Entity
	{
		public static var bullets:Vector.<Bullet> = new Vector.<Bullet>();
		
		public function Bullet(target:Point,startPoint:Point, type:int=1, range:Number = 1, damage:int = 1)
		{
			super();
			var lenX:Number = target.x - startPoint.x;
			var lenY:Number = target.y - startPoint.y;
			var newVector:Point = new Point(lenX,lenY);
			//var bounds:Point = new Point((newVector.x + startPoint.x) * 2, (newVector.y + startPoint.y)* 2);
			addComponent(new Spatial(this,startPoint.x,startPoint.y,0,0,0));
			switch(type){
				case 1:
					addComponent(new Displayable(this,"BULLET_YELLOW"));
					break;
				case 2:
					addComponent(new Displayable(this,"BULLET_RED"));
					break;
				case 3:
					addComponent(new Displayable(this,"BULLET_GREEN"));
					break;
				case 4:
					addComponent(new Displayable(this,"BULLET_BLUE"));
					break;
				default:
				addComponent(new Displayable(this,"BULLET_YELLOW"));
				break;
			}
			addComponent(new Drawing(this));
			addComponent(new Living(this, damage));
			var dist:Rectangle = new Rectangle(startPoint.x-(range *250),startPoint.y-(range *250),500 * range,500 * range);
			var rangeVector:Vector.<Rectangle> = new Vector.<Rectangle>();
			rangeVector.push(dist);
			addComponent(new Physics(this,(newVector.x/newVector.length) * 8,(newVector.y/newVector.length) * 8,1,rangeVector));
			addComponent(new Collidable(this,hitSomething));
			bullets.push(this);
		}
		
		public function hitSomething(e:CollisionEvent):void
		{
			var life:Living = Living(getComponent("Living"));
			if(Component(e.collison2).parent is Zombie)
			{
				var zomb:Zombie = Zombie(Component(e.collison2).parent);
				
				var temp:Number = life.health;
				life.health -= Living(zomb.getComponent("Living")).health;
				Living(zomb.getComponent("Living")).health -= temp;
				if(life.health <=0)
				{
					dispose();
					Game.score += temp * 2;
				}
				else
				{
					Game.score += (temp-life.health) * 2;
				}
				zomb.hitByBullet();	
			}			
		}
	}
}