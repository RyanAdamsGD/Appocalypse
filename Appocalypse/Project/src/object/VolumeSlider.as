package object
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import feathers.controls.Slider;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.display.Image;
	import starling.events.Event;

	public class VolumeSlider extends Slider
	{
		public function VolumeSlider(pos:Point, val:Number, max:Number = 100, min:Number = 0, step:Number =1, page:Number =10)
		{
			minimum = min;
			maximum = max;
			value = val;
			x = pos.x;
			y = pos.y;
			visible = true;
			trackLayoutMode = TRACK_LAYOUT_MODE_SINGLE;
			
			thumbProperties.defaultSkin = new Image(Assets.getAtlas().getTexture("VOLUME_THUMB"));
			thumbProperties.downSkin = new Image(Assets.getAtlas().getTexture("VOLUME_THUMB"));
			thumbProperties.hoverSkin = new Image(Assets.getAtlas().getTexture("VOLUME_THUMB"));
			
			minimumTrackProperties.defaultSkin = new Scale9Image(new Scale9Textures(Assets.getAtlas().getTexture("VOLUME_TRACK"),new Rectangle(1,1,1,1)));
			minimumTrackProperties.downSkin = null;//new Scale9Image(new Scale9Textures(Assets.getAtlas().getTexture("VOLUME_TRACK"),new Rectangle(1,1,1,1)));
			maximumTrackProperties.defaultSkin = null;//new Scale9Image(new Scale9Textures(Assets.getAtlas().getTexture("VOLUME_TRACK"),new Rectangle(1,1,1,1)));
			maximumTrackProperties.downSkin = new Scale9Image(new Scale9Textures(Assets.getAtlas().getTexture("VOLUME_TRACK"),new Rectangle(1,1,1,1)));
			
			addEventListener(Event.CHANGE, onSliderMoved);
		}
		
		private function onSliderMoved(e:Event):void
		{
			var slider:Slider = Slider(e.currentTarget);
			Sounds.volume = slider.value/200;
		}		
		
	}
}