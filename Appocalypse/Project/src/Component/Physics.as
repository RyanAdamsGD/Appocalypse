package Component
{
	import com.greensock.easing.Bounce;
	
	import flash.geom.Rectangle;
	
	import entities.Entity;
		
	public class Physics extends Component
	{
		private var _velocityX:Number;
		private var _velocityY:Number;
		private var _speed:Number;
		private static var physicsList:Vector.<Physics> = new Vector.<Physics>();
		private var bounds:Vector.<Rectangle>;
		public static const MIN_WIDTH:Number = -6200;
		public static const MIN_HEIGHT:Number = -200;
		public static const MAX_WIDTH:Number = 7000;
		public static const MAX_HEIGHT:Number = 5500;
		
		public function Physics( parent:Entity, velocityX:Number,velocityY:Number,speed:Number = 1, bounds:Vector.<Rectangle> = null)
		{
			super("Physics", parent);
			this.velocityX = velocityX;
			this.velocityY = velocityY;
			this.speed = speed;
			this.bounds = bounds;
			if(this.bounds == null)
			{
				this.bounds = new Vector.<Rectangle>();
				this.bounds.push(new Rectangle(MIN_WIDTH,MIN_HEIGHT,MAX_WIDTH,MAX_HEIGHT));
			}
			physicsList.push(this);
		}
		
		public static function update(dt:Number):void
		{
			for(var i:uint=0;i<physicsList.length;i++)
			{
				var where:Physics = physicsList[i];
				var position:Spatial = Spatial(where.getComponent("Spatial"));
				if(position != null)
				{
					position.worldX += where.velocityX * dt * 60;
					position.worldY += where.velocityY * dt * 60;
					var inBounds:Boolean = false;
					for(var j:uint=0;j<where.bounds.length && !inBounds;j++)
					{
						inBounds = where.bounds[j].contains(position.worldX,position.worldY);
					}
					if(!inBounds)
					{
						where.disposeOfParent();
					}
				}
			}
		}
		override public function cleanUp():void
		{
			for(var i:uint=0;i<physicsList.length;i++)
			{
				if(physicsList[i] == this || physicsList[i] == null)
					physicsList.splice(i--, 1);
			}
		}
		
		public function get velocityY():Number
		{
			return _velocityY;
		}

		public function set velocityY(value:Number):void
		{
			_velocityY = value;
		}

		public function get velocityX():Number
		{
			return _velocityX;
		}

		public function set velocityX(value:Number):void
		{
			_velocityX = value;
		}

		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}

	}
}