package entities
{
	import flash.geom.Point;
	
	import Component.Spatial;
	import object.Store;
	import screens.Game;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class HUD extends Entity
	{
		//turret buttons
		private var T1button:Button;
		private var T2button:Button;
		private var T3button:Button;
		private var T4button:Button;
		//gun buttons
		private var G1button:Button;
		private var G2button:Button;
		private var G3button:Button;
		private var G4button:Button;
		private var store:Store;
		private var placeItem:Boolean;
		private var itemClicked:Button;
		private var placedItem:Entity;
		private var turretButton:Vector.<Button> = new Vector.<Button>();
		private var gunButton:Vector.<Button> = new Vector.<Button>(); 
		private var gunsOwned:Vector.<Button> = new Vector.<Button>();
		
		private var minimapDisplay:Hud_Minimap;
		private var turretbarDisplay:Hud_TurretBar;
		private var storeDisplay:Hud_Store;
		private var statbarDisplay:Hud_StatBar;
		
		private var guns:Vector.<Boolean>;
		public static var activeGun:int = 0;
		
		public function HUD()
		{
			super();
			store = new Store();
			placeItem = false;
			
			guns = new Vector.<Boolean>();
			for (var i:int = 0; i < 4; i++) 
			{
				guns.push(false);
			}
			
			guns[0] = true;
			
//			minimapDisplay = new Hud_Minimap();
//			turretbarDisplay  = new Hud_TurretBar();
			storeDisplay = new Hud_Store();
			statbarDisplay = new Hud_StatBar();
			
			
			T1button = new Button(Assets.getAtlas().getTexture("TURRET_1"));
			T1button.x = 555; //560
			T1button.y = 445; //500
			//T1button.rotation = deg2rad(-90);
			Starling.current.stage.addChild(T1button);
			turretButton.push(T1button);
			
			T2button = new Button(Assets.getAtlas().getTexture("TURRET_2"));
			T2button.x = 615; //620
			T2button.y = 450; //500
			//T2button.rotation = deg2rad(-90);
			T2button.enabled = false;
			Starling.current.stage.addChild(T2button);
			turretButton.push(T2button);
			
			T3button = new Button(Assets.getAtlas().getTexture("TURRET_3"));
			T3button.x = 675; //680
			T3button.y = 450; //500
			//T3button.rotation = deg2rad(-90);
			T3button.enabled = false;
			Starling.current.stage.addChild(T3button);
			turretButton.push(T3button);
			
			T4button = new Button(Assets.getAtlas().getTexture("TURRET_4"));
			T4button.x = 735; //740
			T4button.y = 450; //500
			//T4button.rotation = deg2rad(-90);
			T4button.enabled = false;
			Starling.current.stage.addChild(T4button);
			turretButton.push(T4button);
			
			G1button = new Button(Assets.getAtlas().getTexture("GUN_1"));
			G1button.x = 560;
			G1button.y = 520;
			Starling.current.stage.addChild(G1button);
			gunButton.push(G1button);
			gunsOwned.push(G1button);
			
			G2button = new Button(Assets.getAtlas().getTexture("GUN_2"));
			G2button.x = 560;
			G2button.y = 550;
			G2button.enabled = false;
			Starling.current.stage.addChild(G2button);
			gunButton.push(G2button);
			
			G4button = new Button(Assets.getAtlas().getTexture("GUN_4"));
			G4button.x = 640;
			G4button.y = 520;
			G4button.enabled = false;
			Starling.current.stage.addChild(G4button);
			gunButton.push(G4button);
			
			G3button = new Button(Assets.getAtlas().getTexture("GUN_3"));
			G3button.x = 640;
			G3button.y = 550;
			G3button.enabled = false;
			Starling.current.stage.addChild(G3button);
			gunButton.push(G3button);
			
			
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, onTouch);
			Starling.current.stage.addEventListener(Event.TRIGGERED, onClick);
			
		}
		
		public function visible(value:Boolean):void
		{
			for(var i:uint=0;i<gunButton.length;i++)
				gunButton[i].visible = value;
			for(var j:uint=0;j<turretButton.length;j++)
				turretButton[j].visible=value;
			storeDisplay.visible(value);
		}
		
		public override function dispose():void
		{
			Starling.current.stage.removeChild(G1button);
			Starling.current.stage.removeChild(G2button);
			Starling.current.stage.removeChild(G3button);
			Starling.current.stage.removeChild(G4button);
			Starling.current.stage.removeChild(T1button);
			Starling.current.stage.removeChild(T2button);
			Starling.current.stage.removeChild(T3button);
			Starling.current.stage.removeChild(T4button);
			
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH, onTouch);
			Starling.current.stage.removeEventListener(Event.TRIGGERED, onClick);
			
			statbarDisplay.dispose();
			storeDisplay.dispose();
			
			for(var i:uint=0;i<components.length;i)
			{
				removeComponent(components[i].name);
			}
		}
		
		private function onClick(e:Event):void
		{
			for(var j:int = 0; j < gunButton.length; j++)
			{
				if((e.target as Button == gunButton[j] && Game.score >= 1000 + ((j*2) * 3500)) ||(e.target as Button == gunButton[j] && guns[j]))
				{
					if(!guns[j])
					{
						Game.score -= 1000 + ((j*2)  * 3500);
						guns[j] = true;
					}
					itemClicked = gunButton[j];
					itemClicked.text = "";
					changeGun();
				}
			}
		}
		
		private function onTouch(e:TouchEvent):void
		{	
			var source:Point = new Point();
			var itemOffset:Point = new Point();
			if(Game.time == Game.DAY_TIME)
			{
				if(e.touches[0].phase == TouchPhase.BEGAN && !placeItem)
				{
					for(var i:int = 0; i < turretButton.length; i++)
					{
						var touch:Touch = e.getTouch(turretButton[i], TouchPhase.BEGAN);
						if(touch !=null && Game.score >= 1000 + ((i*2) * 2500))
						{
							Game.score -= 1000 + ((i*2)  * 2500);
							itemClicked = turretButton[i];
							touch.getLocation(Starling.current.stage,source);
							buildTurret(source);
						}
					}
				}
				
				if(e.touches[0].phase == TouchPhase.MOVED && placeItem)
				{
					if(placedItem != null)
					{
						var spatial:Spatial = Spatial(placedItem.getComponent("Spatial"));
						e.touches[0].getLocation(Starling.current.stage,source);
						itemOffset = new Point(itemClicked.width/2, itemClicked.height/2);
						source.x += Game.screenToWorldX - itemOffset.x;
						source.y += Game.screenToWorldY - itemOffset.y;
						
						spatial.worldX = source.x;
						spatial.worldY = source.y;
					}
				}
				
				if(e.touches[0].phase == TouchPhase.ENDED && placeItem)
				{
					Turret(placedItem).onDrop();
					placeItem = false;
					itemClicked= null;
					placedItem = null;
				}
			}
			else if(placeItem)
			{
				for(var j:int = 0; j < turretButton.length; j++)
				{
					if(itemClicked == turretButton[j])
					{
						Game.score += 1000 + ((j*2)  * 2500);
						placedItem.dispose();
						placeItem = false;
						itemClicked = null;
						placedItem = null;
					}
				}
			}
		}
		
		private function changeGun():void
		{
			var type:int = 0;
			if(itemClicked == G1button)
				type = 1;
			if(itemClicked == G2button)
				type = 2;
			if(itemClicked == G3button)
				type = 3;
			if(itemClicked == G4button)
				type = 4;
			
			if(type > 0 && type < 5)
				store.changeGun(type);
		}
		
		private function buildTurret(source:Point):void
		{
			var itemOffset:Point = new Point(itemClicked.width/2, itemClicked.height/2);
			source.x += Game.screenToWorldX - itemOffset.x;
			source.y += Game.screenToWorldY - itemOffset.y;
			
			var type:int = 0;
			if(itemClicked == T1button)
				type = 1;
			if(itemClicked == T2button)
				type = 2;
			if(itemClicked == T3button)
				type = 3;
			if(itemClicked == T4button)
				type = 4;
			
			if(type > 0 && type < 5)
				placedItem = store.makeTurret(source, type);
			
			placeItem = true;
		}
		
		public function update():void
		{
			for(var i:int = 0; i < turretButton.length; i++)
			{
				var button:Button = turretButton[i];
				button.text = "$" + (1000 + ((i*2)  * 2500));
				button.fontColor = 0xFFFFFF;
				if(Game.time == Game.DAY_TIME)
				{
					if(Game.score >= 1000 + ((i*2)  * 2500))
						button.enabled = true;
					else
						button.enabled = false;
				}
				else
					button.enabled = false;
			}
			for(var j:int = 0; j < gunButton.length; j++)
			{
				var buttonGun:Button = gunButton[j];
				if(j > 0 && !guns[j])
				{
					buttonGun.text = "$"+(1000 + ((j*2) * 3500));
					buttonGun.fontColor = 0xFFFFFF;
				}
				else
				{
					buttonGun.text = "";
				}
				if(Game.time == Game.DAY_TIME)
				{
					if((Game.score >= 1000 + ((j*2)  * 3500) || guns[j]) && j!=activeGun)
						buttonGun.enabled = true;
					else
						buttonGun.enabled = false;
				}
				else
					buttonGun.enabled = false;	
				
			}
		}
	}
}