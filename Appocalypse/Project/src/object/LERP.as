package object
{
	import flash.geom.Point;

	public class LERP
	{
		public function LERP()
		{
		}
		
		public static function lerp(start:Point, end:Point, t:Number):Point
		{
			var result:Point = new Point();
			result.x = start.x+(end.x-start.x)*t
			result.y = start.y+(end.y-start.y)*t
			return result;
		}
	}
}