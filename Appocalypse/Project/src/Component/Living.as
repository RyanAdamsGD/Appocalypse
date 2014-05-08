package Component
{
	import entities.Entity;
	
	public class Living extends Component
	{
		private var _health:Number;
		
		public function Living(parent:Entity, health:Number)
		{
			super("Living", parent);
			this.health = health;
		}
		
		
		public function get alive():Boolean
		{
			return health > 0;
		}

		public function get health():Number
		{
			return _health;
		}

		public function kill():void
		{
			parent.dispose();
		}
		public function set health(value:Number):void
		{
			_health = value;
		}

	}
}