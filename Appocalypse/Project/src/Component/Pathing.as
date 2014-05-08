package Component
{
	import flash.geom.Point;
	
	import entities.Entity;
	
	public class Pathing extends Component
	{
		private var nextPoint:Point;
		private static var pathings:Vector.<Pathing> = new Vector.<Pathing>();
		private var pathingPoints:Vector.<Point>;
		private var _overridePoint:Point;
		
		public function Pathing(parent:Entity,pathingPoints:Vector.<Point>, overridePoint:Point)
		{
			super("Pathing", parent);
			this.pathingPoints = pathingPoints;
			this.overridePoint = overridePoint;
			nextPoint = pathingPoints[0];
			pathings.push(this);
		}

		public static function update():void
		{
			for(var i:uint=0;i<pathings.length;i++)
			{
				pathings[i].updatePath();
			}
		}
		public override function cleanUp():void
		{
			for(var i:uint=0;i<pathings.length;i++)
			{
				if(pathings[i] == this)
					pathings.splice(i--,1);
			}
		}
		public function updateMovedPath(shiftPoint:Point):void
		{
			for(var i:uint=0;i<pathingPoints.length;i++)
			{	
				var point:Point = pathingPoints[i];
				point.x += shiftPoint.x;
				point.y += shiftPoint.y;
			}
			overridePoint.x += shiftPoint.x;
			overridePoint.y += shiftPoint.y;
		}
		private function updatePath():void
		{
			var s:Spatial = Spatial(getComponent("Spatial"));
			var currentPosition:Point = new Point(s.worldX,s.worldY);
			var pathVector:Point = new Point(nextPoint.x - currentPosition.x,nextPoint.y - currentPosition.y);
			if(pathVector.length < 50)
			{
				updateNextPathPoint();
			}
			
			var overrideVectorPoint:Point = new Point(overridePoint.x - currentPosition.x,overridePoint.y - currentPosition.y);
			var p:Physics = Physics(getComponent("Physics"));
			
			if(pathVector.length < overrideVectorPoint.length)
			{
				p.velocityX = pathVector.x/pathVector.length * p.speed;
				p.velocityY = pathVector.y/pathVector.length * p.speed;
			}
			else
			{
				p.velocityX = overrideVectorPoint.x/overrideVectorPoint.length * p.speed;
				p.velocityY = overrideVectorPoint.y/overrideVectorPoint.length * p.speed;
			}
		}
		
		private function updateNextPathPoint():void
		{
			for(var i:uint=0;i<pathingPoints.length;i++)
			{	
				if(pathingPoints[i] == nextPoint)
				{
					if(i != pathingPoints.length-1)
					{
						pathingPoints[i+1] = new Point(pathingPoints[i+1].x + (Math.random() * 100-50),pathingPoints[i+1].y + (Math.random() * 100-50));
						nextPoint = pathingPoints[i+1];
						//skip the next index which would update it again
						i++;
					}
					else
					{
						nextPoint = overridePoint;
					}
				}	
			}
		}
		
		public function get overridePoint():Point
		{
			return _overridePoint;
		}
		
		public function set overridePoint(value:Point):void
		{
			_overridePoint = value;
		}
	}
}