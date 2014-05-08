package Component
{
	import flash.geom.Rectangle;
	
	import entities.Entity;
	
	import screens.Game;

	public class Spatial extends Component
	{
		private var _worldX:Number;
		private var _worldY:Number;
		private var _width:Number;
		private var _height:Number;
		private var _rotation:Number;
		
		public function Spatial(parent:Entity, x:Number, y:Number, widith:Number, height:Number, rotation:Number)
		{
			super("Spatial", parent);
			this.worldX = x;
			this.worldY = y;
			this.width = widith;
			this.height = height;
			this.rotation = rotation;
		}
		
		public function get worldY():Number
		{
			return _worldY;
		}

		public function set worldY(value:Number):void
		{
			_worldY = value;
		}

		public function get worldX():Number
		{
			return _worldX;
		}

		public function set worldX(value:Number):void
		{
			_worldX = value;
		}

		public function getWorldRect():Rectangle
		{
			return new Rectangle(_worldX,_worldY,width,height);
		}
		
		public function getScreenRect():Rectangle
		{
			return new Rectangle(screenX, screenY, width, height);
		}

		public function get rotation():Number
		{
			return _rotation;
		}

		public function set rotation(value:Number):void
		{
			_rotation = value;
		}

		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		public function get screenY():Number
		{
			return worldY - Game.screenToWorldY;
		}

		public function get screenX():Number
		{
			return worldX - Game.screenToWorldX;
		}

	}
}