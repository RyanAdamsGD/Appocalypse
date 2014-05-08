package entities
{
	import Component.Drawing;
	import Component.Living;
	import Component.Spatial;
	import Component.Displayable;

	public class House extends Entity
	{
		public function House()
		{
			super();
			addComponent(new Spatial(this, 350, -100, 0,0,0));
			addComponent(new Displayable(this, "HOUSE"));
			addComponent(new Drawing(this));
			addComponent(new Living(this, 100));
		}
	}
}