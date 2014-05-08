package Component
{
	import entities.Entity;

	public class Component
	{
		public var parent:Entity;
		private var _name:String;
		
		public function Component(name:String, parent:Entity)
		{
			this._name = name;
			this.parent = parent;
		}

		public function getComponent(name:String):Component
		{
			return parent.getComponent(name);
		}	
		
		public function removeComponent(name:String):void
		{
			parent.removeComponent(name);
		}
		
		public function disposeOfParent():void
		{
			parent.dispose();
		}
		
		public function cleanUp():void
		{
			
		}
		
		public function get name():String
		{
			return _name;
		}
		
		protected function set name(value:String):void
		{
			_name = value;
		}
	}
}