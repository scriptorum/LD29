package game.handler; 

import com.haxepunk.utils.Key;
import flaxen.core.Flaxen;
import flaxen.core.FlaxenHandler;
import flaxen.core.Log;
import flaxen.service.InputService;
import flaxen.component.*;
import flaxen.common.Easing;
import flaxen.common.LoopType;
 
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;

import ash.core.Node;

#if nape
	#if flash
		import nape.util.BitmapDebug; 
	#else
		import nape.util.ShapeDebug;
	#end
	import nape.util.Debug;
#end

class PlayHandler extends FlaxenHandler
{
	public var f:Flaxen;
  	public var nape:Space;
  	#if nape public var napeDebug:Debug; #end


	public function new(f:Flaxen)
	{
		super();
		this.f = f;
		var gravity = Vec2.weak(0, 600);
		nape = new Space(gravity);
	}

	override public function start(_)
	{ 
		var floor = new Body(BodyType.STATIC);
		floor.shapes.add(new Polygon(Polygon.rect(0, f.baseHeight - 40, 600, 40)));
		floor.space = nape;

		f.newSingleton("wall")
			.add(new Layer(100))
			.add(Position.zero())
			.add(new Image("art/wall.png"))
			.add(Repeating.instance);
		f.newSingleton("floor")
			.add(new Layer(95))
			.add(new Position(0, 538))
			.add(new Image("art/floor.png"));

		f.newComponentSet("climberSet")
			.add(new Layer(20))
			.add(new Rotation(0))
			.add(Offset.center())
			.add(Origin.center());

		// Nape Body
		var bodyPos = new Position(308, 0);
		var body = new Body(BodyType.DYNAMIC);
		body.shapes.add(new Polygon(Polygon.box(63, 90)));
		body.position.setxy(bodyPos.x, bodyPos.y);
		body.angularVel = -1;
		body.space = nape;
		f.newSetSingleton("climberSet", "body")
			.add(new Image("art/climber/body.png"))
			.add(bodyPos)
			.add(body); 

		// Nape Head
		// var bodyPos = new Position(308, 475);
		// var body = new Body(BodyType.DYNAMIC);
		// body.shapes.add(new Circle(60));
		// body.position.setxy(bodyPos.x, bodyPos.y);
		// body.space = nape;
		// f.newSetSingleton("climberSet", "body")
		// 	.add(new Image("art/climber/body.png"))
		// 	.add(bodyPos)
		// 	.add(body); // Nape entity


		#if nape
        napeDebug = new #if flash BitmapDebug #else ShapeDebug #end (
        	com.haxepunk.HXP.width, com.haxepunk.HXP.height, com.haxepunk.HXP.stage.color);
        napeDebug.display.scrollRect = null;
        com.haxepunk.HXP.stage.addChild(napeDebug.display);
        #end

/*
		var rot = new Rotation(-20);
		var tween = new Tween(rot, { angle:20 }, 0.5, Easing.easeInOutQuad);
		tween.loop = LoopType.Both;
		var headPos = Position.zero();
		f.newSetSingleton("climberSet", "head")
			.add(new Image("art/climber/head.png"))
			.add(Offset.center())
			.add(new Origin(50, 64))
			.add(rot).add(headPos).add(tween)
			.add(new RelativePosition(headPos, bodyPos, new Position(0, -80)));

		var shoulderJoint = Position.zero();
		var bicepRot = new Rotation(0);
		tween = new Tween(bicepRot, { angle:360 }, 1.0);
		tween.loop = LoopType.Forward;
		f.newSetSingleton("climberSet", "rightBicep")
			.add(new Image("art/climber/bicep.png"))
			.add(new Offset(-10, -10))
			.add(new Origin(10, 10))
			.add(bicepRot)
			.add(shoulderJoint)
			.add(tween)
			.add(new RelativePosition(shoulderJoint, bodyPos, new Position(20, -28)));
		var elbowJoint = Position.zero();
		f.newEntity()
			.add(new RelativePosition(elbowJoint, shoulderJoint, new Position(50, 0)));

		var forearmRot = new Rotation(0);
		tween = new Tween(forearmRot, { angle:360 }, 1.0);
		tween.loop = LoopType.Forward;
		var forearmPos = Position.zero();
		f.newSetSingleton("climberSet", "rightForearm")
			.add(new Image("art/climber/forearm.png"))
			.add(new Offset(-7, -7))
			.add(new Origin(7, 7))
			.add(forearmRot)
			.add(forearmPos)
			.add(tween)
			.add(new Layer(25)) // put forearm behind bicep
			.add(new RelativePosition(forearmPos, elbowJoint, new Position(44, 10)));

		var handPos = Position.zero();
		f.newSetSingleton("climberSet", "rightHand")
			.add(new Image("art/climber/hand.png"))
			.add(new Offset(-3, -8))
			.add(new Origin(3, 8))
			.add(forearmRot)
			.add(handPos)
			.add(new RelativePosition(handPos, forearmPos, new Position(34, 0)));
*/
	}

	override public function update(_)
	{
		nape.step(com.haxepunk.HXP.elapsed);

		#if nape // Nape debug
			napeDebug.clear();
			napeDebug.draw(nape);
			napeDebug.flush();
		#end

		for(node in f.ash.getNodeList(NapeBodyNode))
		{
			node.position.x = node.body.position.x;
			node.position.y = node.body.position.y;
			if(node.entity.has(Rotation))
			{
				var rot = node.entity.get(Rotation);
				rot.angle = node.body.rotation * 180 / Math.PI;
			}
		}

		var key = InputService.lastKey();
		//...
		InputService.clearLastKey();
	}
}

class NapeBodyNode extends Node<NapeBodyNode>
{
	public var body:Body;
	public var position:Position;
}
