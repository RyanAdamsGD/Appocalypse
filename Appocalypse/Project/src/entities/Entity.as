package entities
{	
	import Component.Component;

	public class Entity
	{
		protected var components:Vector.<Component>;
		
		public function Entity()
		{
			components = new Vector.<Component>();
		}
		
		public function getComponent(name:String):Component
		{
			var index:int = -1;
			var componentToReturn:Component = null;
			for(var i:uint = 0; i<components.length;i++)
			{
				if(components[i].name == name)
				{
					componentToReturn = components[i];
					break;
				}
			}
			return componentToReturn;
		}
		
		public function addComponent(newComponent:Component):void
		{
			components.push(newComponent);
		}
		
		public function dispose():void
		{
 			for(var i:uint=0;i<components.length;i)
			{
				removeComponent(components[i].name);
			}
		}
		
		public function removeComponent(name:String):void
		{
			for(var i:uint = 0; i<components.length;i++)
			{
				if(components[i].name == name)
				{
					components[i].cleanUp();
					components.splice(i--,1);
				}
			}
		}
	}
}