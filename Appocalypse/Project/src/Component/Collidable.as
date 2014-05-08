package Component
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import entities.Entity;
	
	import events.CollisionEvent;
	
	import starling.core.Starling;
	import starling.display.Sprite;

	public class Collidable extends Component
	{
		public static var collidables:Vector.<Collidable> = new Vector.<Collidable>();
		private var type:Number;
		private var checkCollidables:Vector.<Collidable>;
		private var sprite:Sprite;
		
		/**
		 * Param: func is a Functions with params of type CollisionEvent
		 */
		public function Collidable(parent:Entity, func:Function, type:Number = 0)
		{
			super("Collidable", parent);
			
			sprite = new Sprite();
			sprite.addEventListener(CollisionEvent.ON_COLLISION, func);
			
			this.type = type;
			
			addCheckCollidable();
			
			collidables.push(this);
		}
		private function addCheckCollidable():void
		{
			checkCollidables = new Vector.<Collidable>();
			if(collidables.length > 1 && type != collidables[0].type)
				checkCollidables.push(collidables[0]);
			
			for(var i:int = 1; i < collidables.length; i++)
			{
				if(type != collidables[i].type && collidables[i] != null)
				{
					var s:Spatial = Spatial(this.getComponent("Spatial"));
					var c:Spatial = Spatial(collidables[i].getComponent("Spatial"));
					if(c != null && s != null)
						if(new Point((s.worldX + s.width/2)-(c.worldX + c.width/2),(s.worldY + s.height/2)-(c.worldY+c.height/2)).length < 1000)
							checkCollidables.push(collidables[i]);
				}
					
			}
		}
		public function checkCollision(dt:Number):void
		{
			for(var i:int = 0; i < checkCollidables.length; i++)
			{
				var c:Collidable = checkCollidables[i];
				var spatial:Spatial = Spatial(c.getComponent("Spatial"));
				
				if(c != this && spatial != null)
				{
					var s:Spatial = Spatial(this.getComponent("Spatial"));
					if(s != null)
					{
						var collisionRect:Rectangle = s.getWorldRect();
						var collisionOffset:Number;
						
						if(s.width > s.height)
							collisionOffset = s.width/2;
						else
							collisionOffset = s.height/2;
						
						if(spatial.width > spatial.height)
						 	collisionOffset += spatial.width/2;// * dt * 60;
						else
							collisionOffset += spatial.height/2;// * dt * 60;
						if(new Point((spatial.worldX + spatial.width/2)-(s.worldX + s.width/2),(spatial.worldY + spatial.height/2)-(s.worldY+s.height/2)).length < collisionOffset)
							sprite.dispatchEvent(new CollisionEvent(CollisionEvent.ON_COLLISION,this,c,true));
					}
				}
			}
		}
		override public function cleanUp():void
		{
			for(var j:int = 0; j < collidables.length; j++)
			{
				if(collidables[j] == null)
				{
					collidables.splice(j--,1);
				}
				else if(collidables[j] == this)
				{
					collidables.splice(j--,1);
				}
			}
			Starling.current.stage.removeChild(sprite);
		}
		public static function update(dt:Number):void
		{
			for(var j:int = 0; j < collidables.length; j++)
			{
				var c:Collidable = collidables[j];
				if(c == null)
					collidables.splice(j--,1);
				else
					c.checkCollision(dt);
			}
			
		}
	}
}