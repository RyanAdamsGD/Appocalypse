package screens
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import Component.ClickShoot;
	import Component.Collidable;
	import Component.Component;
	import Component.Drawing;
	import Component.Hydration;
	import Component.Living;
	import Component.Movie;
	import Component.Pathing;
	import Component.Physics;
	import Component.Spatial;
	
	import entities.Bullet;
	import entities.Entity;
	import entities.HUD;
	import entities.House;
	import entities.HydrationPouch;
	import entities.Map;
	import entities.Player;
	import entities.Retical;
	import entities.Turret;
	import entities.Zombie;
	
	import events.CollisionEvent;
	import events.NavigationEvent;
	
	import object.LERP;
	import object.VolumeSlider;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class Game extends Sprite
	{
		public static const DAY_TIME:String = "Day";
		public static const NIGHT_TIME:String = "Night";
		public static var time:String;
		private var timeRemaining:Number;
		private var timeRemainingDisplay:String = "Time until ";
		private var timePrevious:Number;
		private var timeCurrent:Number;
		private var elapsed:Number;
		
		public static var level:int;
		
		private var player:Player;
		private var enemies:Vector.<Zombie>;
		private var hud:HUD;
		private var house:House;
		
		private var backgroundBR:Image;
		private var backgroundTL:Image;
		private var backgroundTR:Image;
		private var backgroundBL:Image;
		private var overLayNight:Quad;
		private var map:Map;
		
		private var lastOnRoad:Point;
		private var lastRoad:Vector.<Rectangle>;
		private var keyA:Boolean,keyD:Boolean,keyW:Boolean,keyS:Boolean = false;
		private var againA:Boolean = false,againD:Boolean = false,againW:Boolean = false,againS:Boolean = false;
		public static var score:uint =1000;
		private var scoreText:TextField;
		private var healthText:TextField;
		private var timeText:TextField;
		private var dayText:TextField;	
		private var hydrationText:TextField;
		private var timeValueText:TextField;
		private var continueField:TextField;				
		
		private var activeSpawners:Vector.<Point>;
		
		public static var resettingCamera:Boolean = false;
		private var lerpStart:Point = new Point();
		private const lerpEnd:Point = new Point(0,0);
		private var resetCameraTime:Number =0;
		
		private var retical:Retical;
		public static var screenToWorldX:Number;
		public static var screenToWorldY:Number;
		

		private var pathingTimer:int=0;
		private var collisionTimer:int=0;
		private var endInstruction:Boolean = false;
		private var hydrationPouches:Vector.<HydrationPouch>;
		
		private static var TurretShotVolume:Number;
		private var TurreSoundTransform:SoundTransform;
		
		private var ZombieVoiceVolume:Number;
		private var ZombieSoundTransform:SoundTransform;
		private var flashingTimer:int;
		private var warningText:TextField;
		private var hydrationColor:Point;
		private var slider:VolumeSlider;
		private var SoundControl:SoundChannel;
		private var hydrationLevel:Number;
		
		public function Game()
		{
			super();
			this.visible = false;
			SoundControl = new SoundChannel();
			level = 0;
			elapsed = 0;
			timePrevious = getTimer();
			timeCurrent = getTimer();
			timeRemaining = 0;
			TurretShotVolume = 1;
			ZombieVoiceVolume = 1;
			Sounds.sndAlternateMusic.play(0,999,Sounds.Transform);
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function initialize():void
		{			
			endInstruction = true;
			addEventListener(Event.ENTER_FRAME, showInstructions);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,waitForEnterKey);
			
			var color:Number = 0xFFFFFF;
			continueField = new TextField(280,400,"Press Enter to Continue","MyFontName",24,color);
			continueField.x = 180;
			continueField.y = 50;
			continueField.hAlign = HAlign.CENTER;
			stage.addChild(continueField);
			
			retical = new Retical();
			lastRoad = new Vector.<Rectangle>();
			hud = new HUD();	
			this.visible = true;			
		}
		
		private function onAddedToStage():void
		{				
			stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyPress);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
			backgroundBR = new Image(Assets.getAtlas().getTexture("swampBG"));
			backgroundBR.x = stage.stageWidth;
			backgroundBR.y = stage.stageHeight;
			addChildAt(backgroundBR,0);
			backgroundBL = new Image(Assets.getAtlas().getTexture("swampBG"));
			backgroundBL.x = 0;
			backgroundBL.y = stage.stageHeight;
			addChildAt(backgroundBL,0);
			backgroundTL = new Image(Assets.getAtlas().getTexture("swampBG"));
			backgroundTL.x = 0;
			backgroundTL.y = 0;
			addChildAt(backgroundTL,0);
			backgroundTR = new Image(Assets.getAtlas().getTexture("swampBG"));
			backgroundTR.x = stage.stageWidth;
			backgroundTR.y = 0;
			addChildAt(backgroundTR,0);
			
			overLayNight = new Quad(stage.stageWidth,stage.stageHeight,0x000000);
			overLayNight.x = 0;
			overLayNight.y = 0;
			overLayNight.alpha = 0.9;
			addChild(overLayNight);
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		
			
		}
		
		private function showInstructions():void
		{						
			if(endInstruction)
			{
				addEventListener(Event.ENTER_FRAME, update);
				removeEventListener(Event.ENTER_FRAME, showInstructions);
				time = "twilight"
				player = new Player();
				player.addComponent(new ClickShoot(player));
				enemies = new Vector.<Zombie>();
				activeSpawners = new Vector.<Point>();
				hydrationPouches = new Vector.<HydrationPouch>();
				lastOnRoad = new Point();	
				
				addTextFields();
				
				map = new Map();
				for(var i:uint=0;i<map.roadQuads.length;i++)
					addChild(map.roadQuads[i]);
				map.buildEnvironment();
				placeHydrationPouchs();
				
				house = new House();
				
				resettingCamera = true;
				lerpStart =  new Point(-6800,500);
				timeCurrent = getTimer();
				stage.removeChild(continueField);				
			}
		}
		
		private function addTextFields():void
		{
			var color:Number = 0xFFFFFF;
			healthText = new TextField(300,100,"Health: 0", "MyFontName", 24, color);
			healthText.hAlign = HAlign.LEFT;
			healthText.vAlign = VAlign.TOP;
			healthText.x = 10;
			healthText.y = 5;
			stage.addChild(healthText);
			
			hydrationText = new TextField(300,100,"Hydration: 0", "MyFontName", 24, color);
			hydrationText.hAlign = HAlign.LEFT;
			hydrationText.vAlign = VAlign.TOP;
			hydrationText.x = 160;
			hydrationText.y = 5;
			stage.addChild(hydrationText);
			
			timeText = new TextField(300,100,"Time Remaing:", "MyFontName", 24, color);
			timeText.hAlign = HAlign.LEFT;
			timeText.vAlign = VAlign.TOP;
			timeText.x = 580;
			timeText.y = 5;
			stage.addChild(timeText);
			
			timeValueText = new TextField(300,100,"0", "MyFontName", 32, color);
			timeValueText.hAlign = HAlign.LEFT;
			timeValueText.vAlign = VAlign.TOP;
			timeValueText.x = 735;
			timeValueText.y = 0;
			stage.addChild(timeValueText); 
			
			dayText = new TextField(300,100,"Day: 0", "MyFontName", 24, color);
			dayText.hAlign = HAlign.LEFT;
			dayText.vAlign = VAlign.TOP;
			dayText.x = 450;
			dayText.y = 5;
			stage.addChild(dayText);
			
			scoreText = new TextField(300,100,"Score: 0", "MyFontName", 24, color);
			scoreText.hAlign = HAlign.LEFT;
			scoreText.vAlign = VAlign.TOP;
			scoreText.x = 10;
			scoreText.y = 45;
			stage.addChild(scoreText);
			
			warningText = new TextField(280,100,"","MyFontName",40,0xFFFFFF);
			warningText.x = 280;
			warningText.y = 200;
			stage.addChild(warningText);
			
			slider = new VolumeSlider(new Point(580,50),50);
			stage.addChild(slider);
		}
		
		private function waitForEnterKey(e:KeyboardEvent):void
		{
			//if(e.keyCode == Keyboard.ENTER)
				//score+= 1000;
				//endInstruction = true;
		}
		
		public function disposeTemporarily():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,waitForEnterKey);
			this.visible = false;
		}
		
		public function update():void
		{
			dayNightTimerUpdate();
			Pathing.update();
			makeActiveSpaners();
			UpdateTurrets(elapsed);			
			Collidable.update(elapsed);			
			Physics.update(elapsed);
			Drawing.update();
			Movie.update();
			updateZombies();
			map.update(screenToWorldX,screenToWorldY);
			retical.updatePosition();
			var hydration:Hydration = Hydration(player.getComponent("Hydration"));
			if(hydration !=null)
			{
				hydration.update(elapsed);
				hydrationLevel = hydration.currentHydration;
			}
			if(resettingCamera)
			{
				resetCamera();
				if(player.getComponent("Spatial")  == null)
				{
					
					Collidable.collidables = new Vector.<Collidable>();
					player = new Player();
					Hydration(player.getComponent("Hydration")).currentHydration = hydrationLevel;
					for(var i:uint=0;i<hydrationPouches.length;i++)
					{
						hydrationPouches[i].removeComponent("Collidable");					
						hydrationPouches[i].addComponent(new Collidable(hydrationPouches[i], onHydration,1));
					}
				}
			}
			else
			{
				lerpStart = new Point(screenToWorldX,screenToWorldY);
				checkKeyboard();
			}
			checkGameOver();
		}
		
		private function checkGameOver():void
		{
			var ps:Spatial = Spatial(player.getComponent("Spatial"));
			var goal:Rectangle = new Rectangle(-5900,500,400,400);
			
			var hydration:Hydration = Hydration(player.getComponent("Hydration"));
			if(goal.contains(ps.worldX,ps.worldY) || hydration.currentHydration <= 0)
			{
				removeEventListener(Event.ENTER_FRAME, update);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,waitForEnterKey);
				level = 0;
				score = 1000;
				player.dispose();
				killZombies();
				map.removeEnvironment();
				hud.dispose();
				retical.dispose();
				endInstruction = false;
				stage.removeChild(warningText);
				stage.removeChild(scoreText);
				stage.removeChild(dayText);
				stage.removeChild(timeValueText); 
				stage.removeChild(timeText);
				stage.removeChild(hydrationText);
				stage.removeChild(healthText);
				stage.removeChild(slider);
				map.cleanUP();
				Collidable.collidables = new Vector.<Collidable>();
				for(var b:uint=0; b < Bullet.bullets.length; b++)
				{
					Bullet.bullets[b].dispose();
				}
				for(var k:uint=0;k<map.roadQuads.length;k++)
				{
					removeChild(map.roadQuads[k]);
				}
				for(var i:int=Turret.turrets.length-1;i>=0;i--)
				{
					Turret.turrets[i].dispose();
					Turret.turrets.splice(i,1);
				}
				for(var h:uint = 0; h < hydrationPouches.length; h++)
				{
					hydrationPouches[h].dispose();
					hydrationPouches.splice(h--,1);
				}
				hydrationPouches = new Vector.<HydrationPouch>();
				dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "gameover"}, true));
				if(hydration)
				{
					hydration.currentHydration = hydration.MAX_HYDRATION;
				}
			}
		}
		
		private function dayNightTimerUpdate():void
		{
			checkElapsed();
			timeRemaining -= elapsed;
			var previousTime:String = time;
			scoreText.text = "Score: " + score;
			healthText.text = "Health: " + Living(player.getComponent("Living")).health;
			timeValueText.text = "" + Math.ceil(timeRemaining);
			if(player.getComponent("Hydration"))
			{
				var hydrationLevel:Number = Hydration(player.getComponent("Hydration")).currentHydration;
				hydrationText.text = "Hydration: " + Math.ceil(hydrationLevel);
				hydrationColor = LERP.lerp(new Point(0,0), new Point(255,255),hydrationLevel/100);
				var r:uint = hydrationColor.x << 16;
				hydrationText.color = (hydrationColor.x) | (hydrationColor.y) | 255;
				//hydrationText.color = (0x0000FF - (hydrationLevel/1000) * 0xFFFFFF);
			}
			dayText.text = time + ": " + level;
			
			if(timeRemaining <=0)
			{
				time = "Twilight";
				timeRemainingDisplay = time;
			}
			
			//Day time functionality
			if(time==DAY_TIME)
			{
				timeRemainingDisplay = "Time until " + NIGHT_TIME + ": " + timeRemaining;
				var hydration:Hydration = Hydration(player.getComponent("Hydration"));
				if(hydration.currentHydration <= hydration.dehydrationRate*2 && Math.ceil(timeRemaining)%2 == 0 && Math.ceil(timeRemaining) > 7)
				{
					if(hydration.currentHydration > hydration.dehydrationRate)
						warningText.text = "You will run out of water soon."
					else
						warningText.text = "You will run out of water tonight."
					
					hydrationText.color = 0xFFFFFF;
				}
				else
				{
					hydrationText.color = 0x0000FF;
					warningText.text = "";
				}
				hud.update();
			}
				//Night time functionality
			else if(time==NIGHT_TIME)
			{
				timeRemainingDisplay = "Time until " + DAY_TIME + ": " + timeRemaining;
				
				if(Math.random() > 0.99)
				{
					for(var i:uint;i<map.spawnPoints.length;i++)
					{
						var type:int = 1;
						if(Math.random() > 0.7)
							type =2 ;
						if(Math.random() > 0.985)
							type = -1;
						var spawn:Point = map.spawnPoints[i];
						if(isActiveSpawnPoint(spawn))
						{
							var zom:Zombie = new Zombie(spawn,map.getPathingPoints(map.spawnPathDict[i]), type + Math.floor(level/3));
							enemies.push(zom);
						}
					}
				}
				
			}
			else
			{
				if(previousTime==DAY_TIME)
				{
					//start of night
					SoundControl = Sounds.sndZombieHorde.play(0,0,Sounds.Transform); // sound change
					hud.visible(false);
					player.addComponent(new ClickShoot(player,Player.shootSpeed));
					time = NIGHT_TIME;
					overLayNight.alpha = 0.75;
					//30 seconds
					timeRemaining = 45;
				}
				else
				{
					//start of Day
					SoundControl.stop();
					level++;
					hud.visible(true);
					player.removeComponent("ClickShoot");
					time = DAY_TIME;
					killZombies();
					overLayNight.alpha = 0;
					//3 minutes
					timeRemaining = 15;
				}
			}
		}
		
		private function isActiveSpawnPoint(spawn:Point):Boolean {
			// your code here
			var hasSpawned:Boolean = false;
			for(var i:int = 0; i < activeSpawners.length; i++)
			{
				if(spawn.x == activeSpawners[i].x && spawn.y == activeSpawners[i].y)
					hasSpawned = true;
			}
			return hasSpawned;
		}
		
		private function makeActiveSpaners():void
		{
			for(var i:uint;i<map.spawnPoints.length;i++)
			{
				var spawn:Point = map.spawnPoints[i];
				var playerSpatial:Spatial = Spatial(player.getComponent("Spatial"));
				if(playerSpatial)
				{
					var dist:Number = new Point(spawn.x - playerSpatial.worldX, spawn.y - playerSpatial.worldY).length;
					if(dist < 1800 && !isActiveSpawnPoint(spawn))
					{
						activeSpawners.push(spawn);
						if(time == NIGHT_TIME)
							enemies.push(new Zombie(spawn,map.getPathingPoints(map.spawnPathDict[i]), 2 + Math.floor(level/3)));
					}
				}
			}
		}
		private function resetCamera():void
		{
			if(resetCameraTime<1)
			{
				screenToWorldX = lerpStart.x * (1-resetCameraTime) + lerpEnd.x * resetCameraTime;
				screenToWorldY = lerpStart.y * (1-resetCameraTime) + lerpEnd.y * resetCameraTime;
				resetCameraTime += elapsed/4;
			}
			else
			{
				resettingCamera = false;
				resetCameraTime = 0;
				if(time != DAY_TIME)
					timeRemaining = 0;
			}
		}
		private function shiftBackgrounds(speedX:Number,speedY:Number):void
		{
			if(keyW && !againW)
			{
				//Forward
				backgroundBL.y+= speedY * elapsed * 60;
				backgroundBR.y+= speedY * elapsed * 60;
				backgroundTL.y+= speedY * elapsed * 60;
				backgroundTR.y+= speedY * elapsed * 60;
				if(backgroundBL.y >= stage.stageHeight)
				{
					backgroundBL.y = -stage.stageHeight;
					backgroundBR.y = -stage.stageHeight;
				}
				if(backgroundTL.y >= stage.stageHeight)
				{
					backgroundTL.y=-stage.stageHeight;
					backgroundTR.y=-stage.stageHeight;
				}
			}
			if(keyA && !againA) 
			{
				//Left
				backgroundBL.x+= speedX * elapsed * 60;
				backgroundBR.x+= speedX * elapsed * 60;
				backgroundTL.x+= speedX * elapsed * 60;
				backgroundTR.x+= speedX * elapsed * 60;
				if(backgroundBL.x >= stage.stageWidth)
				{
					backgroundBL.x = -stage.stageWidth;
					backgroundTL.x = -stage.stageWidth;
				}
				if(backgroundTR.x >= stage.stageWidth)
				{
					backgroundBR.x=-stage.stageWidth;
					backgroundTR.x=-stage.stageWidth;
				}
			}
			if(keyD && !againD)
			{
				//Right
				backgroundBL.x-= speedX * elapsed * 60;
				backgroundBR.x-= speedX * elapsed * 60;
				backgroundTL.x-= speedX * elapsed * 60;
				backgroundTR.x-= speedX * elapsed * 60;
				if(backgroundBL.x <= -stage.stageWidth)
				{
					backgroundBL.x = stage.stageWidth;
					backgroundTL.x = stage.stageWidth;
				}
				if(backgroundTR.x <= -stage.stageWidth)
				{
					backgroundBR.x=stage.stageWidth;
					backgroundTR.x=stage.stageWidth;
				}
			}
			if(keyS && !againS)
			{
				//Back
				backgroundBL.y-= speedY * elapsed * 60;
				backgroundBR.y-= speedY * elapsed * 60;
				backgroundTL.y-= speedY * elapsed * 60;
				backgroundTR.y-= speedY * elapsed * 60;
				if(backgroundBL.y <= -stage.stageHeight)
				{
					backgroundBL.y = stage.stageHeight;
					backgroundBR.y = stage.stageHeight;
				}
				if(backgroundTL.y <= -stage.stageHeight)
				{
					backgroundTL.y=stage.stageHeight;
					backgroundTR.y=stage.stageHeight;
				}
			}				
		}
		private function checkKeyboard():void
		{
			var speedX:Number = 3;
			var speedY:Number = 3;
			var playerSpatial:Spatial =Spatial(player.getComponent("Spatial"));
			var onRoad:Boolean = false;
			var lastFramePoint:Point = new Point(screenToWorldX, screenToWorldY);
			var numOfRoads:uint = lastRoad.length;
			
			for(var i:int =0; i < map.road.length; i++)
			{
				if(map.road[i].containsRect(playerSpatial.getWorldRect()))
				{
					if(!onRoad)
					{
						lastRoad = new Vector.<Rectangle>();
					}
					onRoad = true;
					lastRoad.push(map.road[i]);
				}
			}
			
			if(numOfRoads != lastRoad.length)
			{
				againA = false;
				againD = false;
				againS = false;
				againW = false;
			}
			
			if(onRoad)
			{
				lastOnRoad.x = screenToWorldX;
				lastOnRoad.y = screenToWorldY;
				shiftBackgrounds(speedX,speedY);
				if(keyW && !againW)
				{
					//Forward
					screenToWorldY -= speedY * elapsed * 60;
					againS = false;
				}
				if(keyA && !againA) 
				{
					//Left
					screenToWorldX -= speedX * elapsed * 60;
					againD = false;
				}
				if(keyD && !againD)
				{
					//Right
					screenToWorldX += speedX * elapsed * 60;
					againA = false;
				}
				if(keyS && !againS)
				{
					//Back
					screenToWorldY += speedY * elapsed * 60;
					againW = false;
				}				
			}
			else
			{
				if(screenToWorldY > lastOnRoad.y && screenToWorldY + stage.stageHeight/2 + playerSpatial.height > (lastRoad[0].y + lastRoad[0].height))
					againS = true; 	//down
				if(screenToWorldY < lastOnRoad.y && screenToWorldY + stage.stageHeight/2 < lastRoad[0].y)
					againW = true; 	//up
				if(screenToWorldX > lastOnRoad.x && screenToWorldX + stage.stageWidth/2 + playerSpatial.width > (lastRoad[0].x + lastRoad[0].width))
					againD = true;	//right
				if(screenToWorldX < lastOnRoad.x && screenToWorldX + stage.stageWidth/2 < lastRoad[0].x)
					againA = true; 	//left
				screenToWorldX = lastOnRoad.x;
				screenToWorldY = lastOnRoad.y;
			}
			updatePlayer();
		}
		
		private function updateZombies():void
		{
			var s:Spatial = Spatial(player.getComponent("Spatial"));
			if(s != null)
			{
				var overridePoint:Point = new Point(s.worldX,s.worldY);
				for(var i:uint; i < enemies.length;i++)
				{
					var p:Pathing = Pathing(enemies[i].getComponent("Pathing"));
					if(p != null)
					{
						p.overridePoint = overridePoint;
					}
					
					var zombie:Zombie = Zombie.zombies[i];
					var zSpatial:Spatial = Spatial(zombie.getComponent("Spatial"));
					if(zSpatial != null)
					{
						var distX:Number = zSpatial.worldX - screenToWorldX - stage.stageWidth;
						var distY:Number = zSpatial.worldY - screenToWorldY - stage.stageHeight;
						var totaldist:Number = new Point(distX,distY).length;
						if(totaldist > 800)
						{			
							ZombieVoiceVolume = 0;
							ZombieSoundTransform = new SoundTransform(ZombieVoiceVolume,0);		
						}
						else
						{
							ZombieVoiceVolume =  (Sounds.volume - (totaldist / 800))/4;
							ZombieSoundTransform = new SoundTransform(ZombieVoiceVolume,0); 						
						}
						if(zombie.zombieIsHurt)
						{
							Sounds.sndZombieMoan.play(0,1,ZombieSoundTransform);
							zombie.zombieIsHurt = false;
						}
						if(zombie.zombieIsDead)
						{
							Sounds.sndZombieDeath.play(0,1,ZombieSoundTransform);
						}
					}
				}
			}
		}
		
		private function updatePlayer():void
		{
			Spatial(player.getComponent("Spatial")).worldX = stage.stageWidth/2 + screenToWorldX;
			Spatial(player.getComponent("Spatial")).worldY = stage.stageHeight/2 + screenToWorldY;
			var cs:ClickShoot = ClickShoot(player.getComponent("ClickShoot"));
			if(cs != null)
				cs.update(elapsed);
		}
			
		
		private function killZombies():void
		{
			for(var i:uint=0;i<enemies.length;i++)
			{
				enemies[i].dispose();
			}
			enemies = new Vector.<Zombie>();
		}
		
		private function UpdateTurrets(elapsed:Number):void
		{
			for(var i:int =0; i < Turret.turrets.length; i++)
			{
				var turret:Turret = Turret.turrets[i];
				var tSpatial:Spatial = Spatial(turret.getComponent("Spatial"));
				turret.update();
				
				var chancesToShoot:int = Math.floor(enemies.length/10);
				var shootAttempts:int = 0;
				while(shootAttempts < chancesToShoot)
				{
					var selectedZombie:Number = Math.floor(Math.random() * enemies.length);
					if(tSpatial != null)
					{
						var enemy:Zombie = enemies[selectedZombie];
						var spatial:Spatial = Spatial(enemy.getComponent("Spatial"));
						if(spatial != null)
						{
							var dist:Number = new Point(tSpatial.worldX - spatial.worldX, tSpatial.worldY- spatial.worldY).length;
							
							if(dist < turret.type*150 && (Math.random() > (0.65)))
							{
								turret.shoot(new Point(spatial.worldX + spatial.width/2, spatial.worldY + spatial.height/2));
																
								var distanceX:Number =  tSpatial.worldX - screenToWorldX - stage.stageWidth;
								var distanceY:Number = tSpatial.worldY - screenToWorldY - stage.stageHeight;
								var distance:Number = new Point(distanceX,distanceY).length;
							
								if(distance > 800)
								{
									TurretShotVolume = 0;
									TurreSoundTransform = new SoundTransform(TurretShotVolume,0);		
								}
								else
								{
									TurretShotVolume = Sounds.volume - (distance /800)/4;
									TurreSoundTransform = new SoundTransform(TurretShotVolume,0); 						
								}
								
								if(!turret.GunIsOutOfAmmo)
									Sounds.sndTurretShooting.play(0,1,TurreSoundTransform);
								else
									Sounds.sndGunHasNoAmmunition.play(0,1,TurreSoundTransform);
							}
						}
						else
							enemies.splice(selectedZombie,1);
					}
					shootAttempts++;
				}
			}
		}
		
		private function placeHydrationPouchs():void
		{
			for(var p:uint = 0; p < map.PathingPoints.length; p+=4)
			{
				var pathPoint:Point = map.PathingPoints[p];
				hydrationPouches.push(new HydrationPouch(pathPoint,onHydration));
			}
		}
		
		private function onHydration(e:CollisionEvent):void
		{
			var ent:Entity;
			var hydration:Hydration = Hydration(player.getComponent("Hydration"));
			if(hydration !=null && Component(e.collison1).parent is HydrationPouch)
			{
				hydration.currentHydration = hydration.MAX_HYDRATION;
				Sounds.sndDrinkingWater.play(0,1,Sounds.Transform);
				ent = Component(e.collison1).parent
				ent.dispose();
			}
			if(hydration !=null && Component(e.collison2).parent is HydrationPouch)
			{
				hydration.currentHydration = hydration.MAX_HYDRATION;
				Sounds.sndDrinkingWater.play(0,1,Sounds.Transform);
				ent = Component(e.collison2).parent
				ent.dispose();
			}
		}
		private function checkElapsed():void
		{
			timePrevious = timeCurrent;
			timeCurrent = getTimer();
			elapsed = (timeCurrent - timePrevious) * 0.001;
		}
		
		private function onKeyPress(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.W)
			{
				//Forward
				keyW = true;
			}
			if(e.keyCode == Keyboard.A) 
			{
				//Left
				keyA = true;
			}
			if(e.keyCode == Keyboard.D)
			{
				//Right
				keyD = true;
			}
			if(e.keyCode == Keyboard.S)
			{
				//Back
				keyS = true;
			}		
		}
		
		private function onKeyRelease(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.W)
			{
				//Forward
				keyW = false;
				againW = false;
			}
			if(e.keyCode == Keyboard.A) 
			{
				//Left
				keyA = false;
				againA = false;
			}
			if(e.keyCode == Keyboard.D)
			{
				//Right
				keyD = false;
				againD = false;
			}
			if(e.keyCode == Keyboard.S)
			{
				//Back
				keyS = false;
				againS = false;
			}
		}
	}
}