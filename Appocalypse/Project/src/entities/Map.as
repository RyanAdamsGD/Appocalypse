package entities
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Quad;


	public class Map
	{
		private var _road:Vector.<Rectangle>;
		private var _roadQuads:Vector.<Quad>;		
		private var enviornment:Vector.<Rectangle>;
		private var trees:Vector.<Trees>;
		private var pathingPoints:Vector.<Point>;
		private var _house:Quad;
		private var originalHouse:Point;
		private var _spawnPoints:Vector.<Point>;
		private var _spawnPathDict:Vector.<Number>;
		private var hydrationPouches:Vector.<HydrationPouch>;
		private var goalLocation:PlayerGoalLocation;
		private var spawners:Vector.<ZombieSpawner>;
		
		public function Map()
		{
			goalLocation = new PlayerGoalLocation();
			originalHouse = new Point();
			roadQuads = new Vector.<Quad>();
			road = new Vector.<Rectangle>();
			pathingPoints = new Vector.<Point>();			
			trees = new Vector.<Trees>();
			enviornment = new Vector.<Rectangle>();
			spawnPoints = new Vector.<Point>();
			spawnPathDict= new Vector.<Number>();
			spawners = new Vector.<ZombieSpawner>();
			
			buildRoad();
			buildHouse();
			createSpawningPoints();
			createDictionary();
		}
		public function buildHouse():void
		{			
			house = new Quad(50,30,0xffffff);
			house.x = 350;
			house.y = -100;
			originalHouse.x = 350;
			originalHouse.y = -100;
		}
		
		public function createDictionary():void
		{
			spawnPathDict.push(1);
			spawnPathDict.push(1);
			spawnPathDict.push(3);
			spawnPathDict.push(3);
			spawnPathDict.push(4);
			spawnPathDict.push(5);
			spawnPathDict.push(6);
			spawnPathDict.push(7);
			spawnPathDict.push(8);
			spawnPathDict.push(9);
			spawnPathDict.push(9);
			spawnPathDict.push(10);
			spawnPathDict.push(11);
			spawnPathDict.push(11);//
			spawnPathDict.push(12);
			spawnPathDict.push(13);
			spawnPathDict.push(13);
			spawnPathDict.push(14);
			spawnPathDict.push(14);//
			spawnPathDict.push(14);
			spawnPathDict.push(15);
			spawnPathDict.push(16);
			
			
			spawnPathDict.push(17);
			spawnPathDict.push(18);
			spawnPathDict.push(19);
			spawnPathDict.push(19);
			spawnPathDict.push(21);
			spawnPathDict.push(22);
			spawnPathDict.push(23);
			spawnPathDict.push(25);
			spawnPathDict.push(27);
			spawnPathDict.push(28);
			spawnPathDict.push(28);//
			spawnPathDict.push(28);
			spawnPathDict.push(29);
			spawnPathDict.push(30);
			spawnPathDict.push(31);
			spawnPathDict.push(32);
			spawnPathDict.push(32);
			spawnPathDict.push(34);
			spawnPathDict.push(35);
			spawnPathDict.push(35);
		}
		
		public function buildRoad():void
		{
			var roadWidth:Number = 150;
			var startX:Number = Starling.current.stage.stageWidth/2 - roadWidth/2;
			road.push(new Rectangle(startX,-100,roadWidth,100)); //Holding house
			road.push(new Rectangle(startX,0,roadWidth,2250));
			road.push(new Rectangle(startX - 750,2150,900,roadWidth));
			road.push(new Rectangle(startX - 750,2150,roadWidth,1150));
			
			road.push(new Rectangle(startX - 1150,3150,550,roadWidth));//Dips
			road.push(new Rectangle(startX - 1150,3150,roadWidth,650));
			road.push(new Rectangle(startX - 1550,3650,550,roadWidth));
			road.push(new Rectangle(startX - 1550,3650,roadWidth,700));
			
			road.push(new Rectangle(startX - 2450,4200,1050,roadWidth)); //bottom path
			road.push(new Rectangle(startX - 2450,1750,850,roadWidth)); //back across
			road.push(new Rectangle(startX - 2450,1750,roadWidth,2600)); //Up
			road.push(new Rectangle(startX - 1750,0,roadWidth,1900));// path to top
			
			road.push(new Rectangle(startX - 2950,3000,650,roadWidth));//Short cut 1
			road.push(new Rectangle(startX - 2950,2650,roadWidth,500));
			road.push(new Rectangle(startX - 3450,2650,650,roadWidth)); 
			
			road.push(new Rectangle(startX - 3450,2000,roadWidth,1350)); //other side down
			
			road.push(new Rectangle(startX - 3750,0,2150,roadWidth)); //top down
			road.push(new Rectangle(startX - 3750,0,roadWidth,2150)); //top
			road.push(new Rectangle(startX - 3750,2000,450,roadWidth)); //cut back other side
			
			road.push(new Rectangle(startX - 4450,3200,1150,roadWidth)); //cross middle
			
			road.push(new Rectangle(startX - 4450,1750,roadWidth,1550)); //short cut #2 down, and path up
			road.push(new Rectangle(startX - 5450,2650,1150,roadWidth));
			
			road.push(new Rectangle(startX - 3800,3200,roadWidth,1600)); //long route
			road.push(new Rectangle(startX - 3800,4650,500,roadWidth));
			road.push(new Rectangle(startX - 3450,4650,roadWidth,500));
			road.push(new Rectangle(startX - 4450,5000,1150,roadWidth)); // long route bottom
			road.push(new Rectangle(startX - 4450,4000,roadWidth,1150));
			road.push(new Rectangle(startX - 4450,4000,450,roadWidth));
			road.push(new Rectangle(startX - 4150,3200,roadWidth,950));
			
			road.push(new Rectangle(startX - 5450,2650,1150,roadWidth));//end path
			road.push(new Rectangle(startX - 5450,2000,roadWidth,800));//down
			road.push(new Rectangle(startX - 5450,2000,600,roadWidth)); //cross
			road.push(new Rectangle(startX - 5000,1150,roadWidth,1000));
			road.push(new Rectangle(startX - 5000,1750,700,roadWidth));//short cut
			
			road.push(new Rectangle(startX - 5000,1150,600,roadWidth));
			road.push(new Rectangle(startX - 4550,600,roadWidth,700));
			road.push(new Rectangle(startX - 6000,600,1600,roadWidth));//END
			
			
			pathingPoints.push(new Point(startX-5700,650));35
			pathingPoints.push(new Point(startX-4550,650));
			pathingPoints.push(new Point(startX-4550,1200));
			pathingPoints.push(new Point(startX-5000,1200));
			pathingPoints.push(new Point(startX-5000,1800));
			pathingPoints.push(new Point(startX-5050,2050));
			//shortcut would go here 30
			pathingPoints.push(new Point(startX-5450,2050));
			//pathingPoints.push(new Point(startX-4050,1800));
			pathingPoints.push(new Point(startX-5450,2700));
			pathingPoints.push(new Point(startX-4450,2700));
			//end shortcut
			pathingPoints.push(new Point(startX-4450,3200));
			pathingPoints.push(new Point(startX-4150,3250));
			//shortcut would go here 25
			pathingPoints.push(new Point(startX-4150,4050));
			pathingPoints.push(new Point(startX-4450,4050));	
			pathingPoints.push(new Point(startX-4450,5050));
			pathingPoints.push(new Point(startX-3450,5050)); 
			pathingPoints.push(new Point(startX-3450,4700));
			//end shortcut 20
			pathingPoints.push(new Point(startX-3800,4700));
			pathingPoints.push(new Point(startX-3830,3250)); 
			pathingPoints.push(new Point(startX-3450,3250));
			pathingPoints.push(new Point(startX-3450,2750));
			//shortcut would go here 
			pathingPoints.push(new Point(startX-3450,2050));
			//pathingPoints.push(new Point(startX-2550,2700));
			//pathingPoints.push(new Point(startX-2550,3050));
			pathingPoints.push(new Point(startX-3750,2050));
			pathingPoints.push(new Point(startX-3750,50));			
			pathingPoints.push(new Point(startX-1700,50));
			pathingPoints.push(new Point(startX-1700,1800)); 
			pathingPoints.push(new Point(startX-2400,1800));
			//end shortcut 10
			pathingPoints.push(new Point(startX-2400,3050));
			pathingPoints.push(new Point(startX-2400,4250));
			pathingPoints.push(new Point(startX-1500,4250));			
			pathingPoints.push(new Point(startX-1500,3700));
			pathingPoints.push(new Point(startX-1100,3700));
			pathingPoints.push(new Point(startX-1100,3200));
			pathingPoints.push(new Point(startX-700,3200));
			pathingPoints.push(new Point(startX-700,2200));
			pathingPoints.push(new Point(startX,2200));
			pathingPoints.push(new Point(startX,-120));
			
			
			for(var i:uint=0;i<road.length;i++)
			{
				roadQuads.push(new Quad(road[i].width,road[i].height,0x000000));
				roadQuads[i].x = road[i].x;
				roadQuads[i].y = road[i].y;
			}
			
		}
		
		public function removeEnvironment():void
		{
			enviornment = new Vector.<Rectangle>();
			
			for(var j:int=0;j<trees.length;j++)
			{
				trees[j].dispose();
			}
			trees = new Vector.<Trees>();
		}
		
		public function buildEnvironment():void
		{
			var roadWidth:Number = 350;			
			
			for(var x:int=-6450;x<900;x+=200)
			{
				for(var y:int=-300;y<5500;y+=180)
				{
					enviornment.push(new Rectangle(x,y,30,40));
				}
			}
			
			
			for(var i:uint=0;i<enviornment.length;i++)
			{
				var rect:Rectangle = enviornment[i];
				var onRoad:Boolean = false;
				for(var r:int = 0; r < road.length; r++)
				{
					if(road[r].intersects(rect))
						onRoad = true;
				}
				if(!onRoad)
					if(Math.random() > 0.7)
						trees.push(new Trees(new Point(rect.x, rect.y), i % 4));
			}
		}
		
		public function update(screenToWorldX:Number, screenToWorldY:Number):void
		{
			house.x = originalHouse.x - screenToWorldX;
			house.y = originalHouse.y - screenToWorldY;
			
			for(var j:uint=0;j<roadQuads.length;j++)
			{
				roadQuads[j].x = road[j].x - screenToWorldX;
				roadQuads[j].y = road[j].y - screenToWorldY;
			}
		}
		
		public function createSpawningPoints():void
		{
			spawnPoints.push(new Point(100,1180));
			spawnPoints.push(new Point(650,1850));
			spawnPoints.push(new Point(-550,2100));
			spawnPoints.push(new Point(-600,2480));
			spawnPoints.push(new Point(-550,3080));
			spawnPoints.push(new Point(-1000,3220));
			spawnPoints.push(new Point(-1000,3930));
			spawnPoints.push(new Point(-1200,3600));
			spawnPoints.push(new Point(-1200,4500));
			spawnPoints.push(new Point(-1940,4100));
			spawnPoints.push(new Point(-1900,3650));
			spawnPoints.push(new Point(-2300,2650));
			spawnPoints.push(new Point(-2300,2000));
			spawnPoints.push(new Point(-1800,1680));
			spawnPoints.push(new Point(-1600,700));
			spawnPoints.push(new Point(-2000,240));
			spawnPoints.push(new Point(-2800,-80));
			spawnPoints.push(new Point(-3600,240));
			spawnPoints.push(new Point(-3200,600));
			spawnPoints.push(new Point(-3200,1400));
			
			spawnPoints.push(new Point(-3530,2000));
			spawnPoints.push(new Point(-2880,2500));
			spawnPoints.push(new Point(-3400,3100));
			spawnPoints.push(new Point(-3230,3500));
			spawnPoints.push(new Point(-3630,4700));
			spawnPoints.push(new Point(-3500,5300));
			spawnPoints.push(new Point(-4300,4500));
			spawnPoints.push(new Point(-3950,3800));
			spawnPoints.push(new Point(-3900,3000));
			spawnPoints.push(new Point(-3900,2600));
			
			spawnPoints.push(new Point(-4600,2500));
			spawnPoints.push(new Point(-5000,2900));
			spawnPoints.push(new Point(-4400,2000));
			spawnPoints.push(new Point(-5330,2200));
			spawnPoints.push(new Point(-4900,1700));
			spawnPoints.push(new Point(-4300,1400));
			spawnPoints.push(new Point(-4700,1000));
			spawnPoints.push(new Point(-4150,550));			
			spawnPoints.push(new Point(-5200,500));
			spawnPoints.push(new Point(-5400,850));
			
			for(var s:int =0; s < spawnPoints.length; s++)
			{
				spawners.push(new ZombieSpawner(spawnPoints[s]));
			}
		}
		
		public function cleanUP():void
		{
			for(var i:uint;i<spawners.length;i++)
			{
				spawners[i].dispose();
			}
		}
		
		public function getPathingPoints(index:Number):Vector.<Point>
		{
			var path:Vector.<Point> = new Vector.<Point>();
			for(var i:uint=pathingPoints.length-index;i<pathingPoints.length;i++)
				path.push(pathingPoints[i]);
			return path;
		}
		public function get PathingPoints():Vector.<Point>
		{
			return pathingPoints;
		}
		public function get road():Vector.<Rectangle>
		{
			return _road;
		}

		public function set road(value:Vector.<Rectangle>):void
		{
			_road = value;
		}

		public function get roadQuads():Vector.<Quad>
		{
			return _roadQuads;
		}

		public function set roadQuads(value:Vector.<Quad>):void
		{
			_roadQuads = value;
		}

		public function get house():Quad
		{
			return _house;
		}

		public function set house(value:Quad):void
		{
			_house = value;
		}

		public function get spawnPoints():Vector.<Point>
		{
			return _spawnPoints;
		}

		public function set spawnPoints(value:Vector.<Point>):void
		{
			_spawnPoints = value;
		}

		public function get spawnPathDict():Vector.<Number>
		{
			return _spawnPathDict;
		}

		public function set spawnPathDict(value:Vector.<Number>):void
		{
			_spawnPathDict = value;
		}

		
	}
}