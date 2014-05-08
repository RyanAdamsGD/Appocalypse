package entities
{
	import Component.Component;
	
	import starling.display.Stage;

	public class mapLocation extends Component
	{
		private var X:int;
		private var Y:int;
		private var _canMoveOn:Boolean;
		private var _canPlaceOn:Boolean;
		private var _isRoad:Boolean;
		
		public function mapLocation(parent:Entity, _X:int,_Y:int, _canMoveOn:Boolean, _canPlaceOn:Boolean,_isRoad:Boolean)
		{
			super("mapLocation", parent);
			X = _X;
			Y = _Y;
			this._canMoveOn = _canMoveOn;
			this._canPlaceOn = _canPlaceOn;
			this._isRoad = _isRoad;
		}
	
		public function get isRoad():Boolean
		{
			return _isRoad;
		}
		public function set isRoad(value:Boolean):void
		{
			_isRoad = value;
		}
		public function get canPlaceOn():Boolean
		{
			return _canPlaceOn;
		}

		public function set canPlaceOn(value:Boolean):void
		{
			_canPlaceOn = value;
		}

		public function get canMoveOn():Boolean
		{
			return _canMoveOn;
		}

		public function set canMoveOn(value:Boolean):void
		{
			_canMoveOn = value;
		}

		public function get y():int
		{
			return Y;
		}

		public function set setY(value:int):void
		{
			Y = value;
		}

		public function get x():int
		{
			return X;
		}

		public function set setX(value:int):void
		{
			X = value;
		}
		
	}
}