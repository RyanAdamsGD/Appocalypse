package events
{
	import starling.display.Button;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class StoreClick extends TouchEvent
	{
		public static const ON_CLICK:String = "onClick";
		
		public var item:Button;
		
		public function StoreClick(type:String, touches:Vector.<Touch>, param:Button = null, shiftKey:Boolean=false, ctrlKey:Boolean=false, bubbles:Boolean=true)
		{
			super(type, touches, shiftKey, ctrlKey, bubbles);
			item = param;
		}
	}
}