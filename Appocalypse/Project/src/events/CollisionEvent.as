package events
{
	import starling.events.Event;
	
	public class CollisionEvent extends Event
	{
		public static const ON_COLLISION:String = "onCollision";
		
		public var collison1:Object;
		public var collison2:Object;
		public function CollisionEvent(type:String, _params:Object = null, _params2:Object = null, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
			this.collison1 = _params;
			this.collison2 = _params2;
		}
	}
}