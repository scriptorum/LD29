package game.handler; 

import com.haxepunk.utils.Key;
import flaxen.core.Flaxen;
import flaxen.core.FlaxenHandler;
import flaxen.core.Log;
import flaxen.service.InputService;
import flaxen.component.*;

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

		var parent = new Position(100, 100);
		var child = new Position(10, 10);
		var absolute = Position.zero();
		var relative = new RelativePosition(absolute, parent, child);
		trace(" - parent:" + parent + " child:" + child + " abs:" + absolute);
		child.set(5, 5);
		trace(" - parent:" + parent + " child:" + child + " abs:" + absolute);
		parent.set(50, 50);
		trace(" - parent:" + parent + " child:" + child + " abs:" + absolute);
		child.x = 20;
		child.y = 40;
		trace(" - parent:" + parent + " child:" + child + " abs:" + absolute);

		f.newComponentSet("climberSet")
			.add(new Layer(20));

		var parentPos = new Position(308, 475);
		f.newSetSingleton("climberSet", "body")
			.add(new Image("art/climber/body.png"))
			.add(Offset.center())
			.add(Origin.center())
			.add(parentPos);
	}

	override public function update(_)
	{
		var key = InputService.lastKey();
		//...
		InputService.clearLastKey();
	}
}
