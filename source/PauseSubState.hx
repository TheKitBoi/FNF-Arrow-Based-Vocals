package;

import flixel.math.FlxMath;
import flixel.math.FlxVelocity;
import flixel.addons.effects.chainable.FlxOutlineEffect;
import flixel.text.FlxText;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

class PauseSubState extends MusicBeatSubstate
{	
	//DD: OG game uses Alphabet class, which only supports English.
	//Gonna have to use FlxText instead.
	var grpMenuShit:FlxTypedGroup<FlxText>;

	var menuItems:Array<String> = ['ゲーム再開', '再び起動', 'メニューに戻る'];
	var curSelected:Int = 0;

	var gapSizeY:Float = 120;
	var gapSizeX:Float = 20;

	var pauseMusic:FlxSound;

	public function new(x:Float, y:Float)
	{
		super();

		pauseMusic = new FlxSound().loadEmbedded('assets/music/breakfast' + TitleState.soundExt, true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

		grpMenuShit = new FlxTypedGroup<FlxText>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			// var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			// songText.isMenuItem = true;
			var songText:FlxText = new FlxText(gapSizeX * i + 100, (gapSizeY * i) + FlxG.height / 2, 0, menuItems[i], 80);
			songText.setFormat("assets/fonts/deltagothic.ttf", songText.size, FlxColor.WHITE, LEFT, SHADOW, FlxColor.BLACK);
			songText.borderSize = 12;
			songText.borderQuality = 1;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "ゲーム再開":
					close();
				case "再び起動":
					FlxG.resetState();
				case "メニューに戻る":
					FlxG.switchState(new MainMenuState());
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}

		for (i in 0...grpMenuShit.members.length)
		{
			var targetY = (gapSizeY * i) + FlxG.height / 2 - gapSizeY * curSelected;
			var targetX = gapSizeX * i + 100 - gapSizeX * curSelected;
			if (grpMenuShit.members[i].y != targetY)
			{
				grpMenuShit.members[i].y = FlxMath.lerp(grpMenuShit.members[i].y, targetY, 0.16);
				grpMenuShit.members[i].x = FlxMath.lerp(grpMenuShit.members[i].x, targetX, 0.16);
			}
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		// var bullShit:Int = 0;

		for (i in 0...grpMenuShit.members.length)
		{
			// item.targetY = bullShit - curSelected;
			// bullShit++;

			grpMenuShit.members[i].alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (i == curSelected)
			{
				grpMenuShit.members[i].alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
