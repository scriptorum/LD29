package game.handler; 

import com.haxepunk.utils.Key;
import flaxen.core.Flaxen;
import flaxen.core.FlaxenHandler;
import flaxen.core.Log;
import flaxen.service.InputService;
import flaxen.component.*;
import flaxen.common.Easing;
import flaxen.common.LoopType;
 
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
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
			.add(new Rotation(0))
			.add(Offset.center())
			.add(Origin.center());

		// dim / pos / pivot (times dim) / mirror / anchor
		var lay1 = new Layer(20);
		var lay2 = new Layer(21);
		var lay3 = new Layer(22);
		var lay4 = new Layer(23);
		var body = addNapeEntity("body", 63, 90, 1, -96, .516, .627, lay1, false, null);
		var head = addNapeEntity("head", 101, 84, 1, -149, .5, .94, lay2, false, body);
		var bicep = addNapeEntity("bicep", 60, 20, 22, -133, .064, .55, lay2, true, body);
		var forearm = addNapeEntity("forearm", 44, 13, 65, -134, .1, .48, lay3, true, bicep);
		var hand = addNapeEntity("hand", 14, 16, 96, -135, .042, .469, lay4, true, forearm);
		var thigh = addNapeEntity("thigh", 30, 62, 13, -78, .484, .238, lay2, true, body);
		var foreleg = addNapeEntity("foreleg", 18, 47, 14, -43, .579, .104, lay3, true, thigh);
		var foot = addNapeEntity("foot", 15, 9, 15, -4, .200, .525, lay4, true, foreleg);

		#if nape
        napeDebug = new #if flash BitmapDebug #else ShapeDebug #end (
        	com.haxepunk.HXP.width, com.haxepunk.HXP.height, com.haxepunk.HXP.stage.color);
        napeDebug.display.scrollRect = null;
		napeDebug.drawConstraints = true;
        com.haxepunk.HXP.stage.addChild(napeDebug.display);
        #end
	}

	// TODO implement mirror, not that name needs to explicity for the entity name
	// (e.g, handLeft) vs the filename (e.g. hand)
	private function addNapeEntity(name:String, width:Float, height:Float, 
		posX:Float, posY:Float, pivotX:Float, pivotY:Float, layer:Layer,
		mirror:Bool, anchor:Body): Body
	{
		var shrinkage = 0.7;
		pivotX -= 0.5;
		pivotY -= 0.5;
		var pos = new Position(300 + posX - pivotX * width, 300 + posY - pivotY * height);
		var body = new Body(anchor == null ? BodyType.STATIC : BodyType.DYNAMIC);
		var shape = new Polygon(Polygon.box(width * shrinkage, height * shrinkage));
		shape.sensorEnabled = true;
		body.shapes.add(shape);
		body.position.setxy(pos.x, pos.y);
		body.space = nape;

		if(anchor != null)
		{
			var worldAnchorPoint = new Vec2(pos.x + pivotX * width, pos.y + pivotY * height);
			var bodyPivot = body.worldPointToLocal(worldAnchorPoint);
			var anchorPivot = anchor.worldPointToLocal(worldAnchorPoint);
			trace("Connecting joint " + name + " at " + worldAnchorPoint + " bodyLocal:" + bodyPivot 
				+ " anchorLocal:" + anchorPivot);
			var joint = new PivotJoint(body, anchor, bodyPivot, anchorPivot);			
			joint.debugDraw = true;
			// joint.stiff = false;
			joint.space = nape;
		}

		var e = f.newSetSingleton("climberSet", name)
			.add(new Image("art/climber/" + name + ".png"))
			.add(pos).add(body).add(layer);

		return body;
	}

	override public function update(_)
	{
		nape.step(com.haxepunk.HXP.elapsed);

		#if nape // Nape debug
			napeDebug.clear();
			napeDebug.draw(nape);
			napeDebug.flush();
		#end

		// Update objects with a nape representation
		// TODO move to a system
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
