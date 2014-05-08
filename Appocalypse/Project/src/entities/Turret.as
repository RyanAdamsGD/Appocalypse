package entities
{
	import flash.geom.Point;
	
	import Component.Displayable;
	import Component.Drawing;
	import Component.Living;
	import Component.Spatial;
	
	import screens.Game;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	public class Turret extends Entity
	{
		public static var turrets:Vector.<Turret> = new Vector.<Turret>();
		public var type:int;
		private var _roundsFired:int; 
		private var MAX_AMMO:int; 
		private var ammoText:TextField
		private var ammoButton:Button;
		private var _GunIsOutOfAmmo:Boolean = false;
		
		public function Turret(source:Point, type:int, maxAmmo:int = 10000)
		{
			super();
			MAX_AMMO = maxAmmo;
			addComponent(new Displayable(this,"TURRET_" + type));
			var height:Number = Displayable(getComponent("Displayable")).height;
			var width:Number = Displayable(getComponent("Displayable")).width;
			var spatial:Spatial = new Spatial(this,source.x + Game.screenToWorldX,source.y + Game.screenToWorldY,width,height,0);
			addComponent(spatial);
			addComponent(new Drawing(this));
			addComponent(new Living(this,10));
			turrets.push(this);
			
			this.type = type;
		}
		
		public override function dispose():void
		{
			super.dispose();
			Starling.current.stage.removeChild(ammoButton);
			Starling.current.stage.removeChild(ammoText);
		}



		public function onDrop():void
		{
			var spatial:Spatial = Spatial(getComponent("Spatial"));
			var color:Number = 0xFFFFFF;
			ammoText = new TextField(300,100,"ammo: " + MAX_AMMO, "MyFontName", 24, color);
			ammoText.x = spatial.worldX;
			ammoText.y = spatial.worldY - 20;
			ammoText.visible = false;
			ammoButton = new Button(Assets.getAtlas().getTexture("HUD_SMALLBUTTON"));
			ammoButton.x = spatial.worldX-10;
			ammoButton.y = spatial.worldY-30;
			ammoButton.text = "" + MAX_AMMO;
			ammoButton.visible = true;
			ammoButton.enabled = false;
			
			Starling.current.stage.addChild(ammoButton);
			Starling.current.stage.addChild(ammoText);
		}
		public function update():void
		{
			var spatial:Spatial = Spatial(getComponent("Spatial"));
			if(spatial !=null)
			{
				if(ammoText !=null )
				{
					ammoText.x = spatial.screenX - 100;
					ammoText.y = spatial.screenY - 60;
				}
				if(ammoButton !=null)
				{
					ammoButton.x = spatial.screenX - 10;
					ammoButton.y = spatial.screenY - 30;
				}
			}
		}
		public function shoot(target:Point):void
		{
			var spatial:Spatial = Spatial(getComponent("Spatial"));
			if(spatial != null)
			{
				var vec:Point = new Point(target.x - (spatial.worldX), target.y - (spatial.worldY));
				//spatial.rotation = Math.atan2(vec.y, vec.x) + (3* Math.PI) /4;
				if(roundsFired < MAX_AMMO)
				{
					new Bullet(target, new Point(spatial.worldX, spatial.worldY),type,type,type+1);
					roundsFired++;
					if(ammoText !=null)
						ammoText.text = "ammo: " + (MAX_AMMO-roundsFired);
					if(ammoButton !=null)
						ammoButton.text = "" + (MAX_AMMO-roundsFired);
				}
				else if( roundsFired = MAX_AMMO)
				{
					roundsFired++;
					_GunIsOutOfAmmo = true;
					//Reload logic
					if(ammoButton !=null)
					{
						ammoButton.enabled = true;
						ammoButton.text = "$" + (500 + ((type-1) * 4000));
						Starling.current.stage.addEventListener(TouchEvent.TOUCH, onReloadClick);
					}
				}
			}
		}
	
		public function onReloadClick(e:TouchEvent):void
		{
			var touchPoint:Point = new Point(e.touches[0].globalX, e.touches[0].globalY);
			if(e.touches[0].phase == TouchPhase.BEGAN)
			{
				_GunIsOutOfAmmo = false;
				var spatial:Spatial = Spatial(getComponent("Spatial"));
				var distince:Number = new Point((ammoButton.x + ammoButton.width/2) - touchPoint.x, (ammoButton.y + ammoButton.height/2) - touchPoint.y).length
				if(distince < 50 && Game.score >= 500 + ((type-1) * 4000))
				{
					Sounds.sndGunIsBeingReloaded.play(0,0,Sounds.Transform);
					Starling.current.stage.removeEventListener(TouchEvent.TOUCH, onReloadClick);
					roundsFired = 0;
					ammoButton.text = "MAX AMMO";
					ammoButton.enabled = false;
					Game.score -= 500 + ((type-1) * 4000);
				}
			}
		}
		public function get roundsFired():int
		{
			return _roundsFired;
		}

		public function set roundsFired(value:int):void
		{
			_roundsFired = value;
		}
		
		public function get GunIsOutOfAmmo():Boolean
		{
			return _GunIsOutOfAmmo;
		}

	}
}