package entities
{
	import flash.geom.Rectangle;
	import starling.display.Sprite;
	import starling.events.Event;

	public class PlayerHome extends Sprite implements IMapPiece
	{
		private var _setHeight:Number;
		private var _setWidth:Number;
		private var _setX:Number;
		private var _setY:Number;
		private var PieceLocation:Rectangle;
		
		public function PlayerHome()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		public function get GETHEIGHT():Number
		{
			return _setHeight;
		}
		
		public function get GETWIDTH():Number
		{
			return _setWidth;
		}
		
		public function get GETX():Number
		{
			return _setX;
		}
		
		public function get GETY():Number
		{
			return _setY;
		}
		
		public function set SETHEIGHT(value:Number):void
		{
			_setHeight = value;
		}
		
		public function set SETWIDTH(value:Number):void
		{
			_setWidth = value;
		}
		
		public function set SETX(value:Number):void
		{
			_setX = value;
		}
		
		public function set SETY(value:Number):void
		{
			_setY = value;
		}
		
		public function onAddedToStage(event:Event):void
		{
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);
			PieceLocation = new Rectangle(_setX, _setY, _setWidth, _setHeight);
		}
		
	}
}