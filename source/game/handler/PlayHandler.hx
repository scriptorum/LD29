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
	}

	override public function update(_)
	{
		var key = InputService.lastKey();

		#if debug
		if(key == Key.D)
		{
			trace("Dumping log(s)");
			flaxen.util.LogUtil.dumpLog(f, Main.CWD + "entities.txt");
			for(setName in f.getComponentSetKeys())
				trace(setName + ":{" + f.getComponentSet(setName) + "}");
		}
		#end

		InputService.clearLastKey();
	}
}
