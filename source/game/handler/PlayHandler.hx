package game.handler; 

import com.haxepunk.utils.Key;
import flaxen.core.Flaxen;
import flaxen.core.FlaxenHandler;
import flaxen.core.Log;
import flaxen.service.InputService;
import flaxen.component.*;
import flaxen.common.Easing;
import flaxen.common.LoopType;

class PlayHandler extends FlaxenHandler
{
	public var f:Flaxen;

	public function new(f:Flaxen)
	{
		super();
		this.f = f;
	}

	override public function start(_)
	{
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
			.add(new Layer(20));

		var bodyPos = new Position(308, 475);
		f.newSetSingleton("climberSet", "body")
			.add(new Image("art/climber/body.png"))
			.add(Offset.center())
			.add(Origin.center())
			.add(bodyPos);

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

	}

	override public function update(_)
	{
		var key = InputService.lastKey();
		//...
		InputService.clearLastKey();
	}
}
