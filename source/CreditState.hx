package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class CreditState extends MusicBeatState
{
	var curSelected:Int = 0;
	var isinCat:Bool = false;
	var allTheStuff:Array<String> = [];
	var theStuffCat:Array<Int> = [];
	var theLinks:Array<String> = [];
	var catagories:Array<String> = [];
	var labels:Array<String> = [];
	var realLength:Int = 0;
	var curCatagory:Int = 0;
	var prevSelected:Int = 0;
	private var grpCatagories:FlxTypedGroup<Alphabet>;
	private var grpLabel:FlxTypedGroup<Alphabet>;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		catagories = [
			"Jth Channel",
			"Nong vanila",
			"Tsg ch",
			"This mod was not created."

        ];
        var initStuff:Array<String> = [
            "0:youtube://www.youtube.com/channel/UCFM0KvWIkFNTIkN-V6CvkSQ",
			"1:youtube://www.youtube.com/channel/UCGwph3rtuvm9D7yvjceZBbg",
			"2:youtube://www.youtube.com/channel/UCec3R-pT_FQ65eBuUtTDGNw",
			"3:dinvin://www.youtube.com/channel/UCpH2xG3mXWz7Yu3nE_TVS-g",

		];
        labels = [
            "Sprite Maker",
			"Coder And Music",
			"Charter",
			"Sorry, I'm too lazy to draw the background."
        ];
		
		
		for (i in 0...initStuff.length)
		{
			var data:Array<String> = initStuff[i].split(':');
			theStuffCat.push(Std.parseInt(data[0]));
			allTheStuff.push(data[1]);
			theLinks.push("https:" + data[2]);
		}
		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('creadit','ink'));
		bg.animation.addByPrefix('idle', 'creadit00', 24);
		bg.animation.play('idle');
		bg.alpha = 0.7;
		add(bg);

		grpCatagories = new FlxTypedGroup<Alphabet>();
		add(grpCatagories);
		grpLabel = new FlxTypedGroup<Alphabet>();
		add(grpLabel);

		for (i in 0...catagories.length)
		{
			var catagory:Alphabet = new Alphabet(0, (90 * i) + 30, catagories[i], true, false);
			var label:Alphabet = new Alphabet(0, (90 * i) + 30, labels[i], true, false);
			label.alpha = 0.5;
			//catagory.move = false;
			catagory.isMenuItem = true;
			catagory.targetY = i;
			grpCatagories.add(catagory);
			realLength++;
			grpLabel.add(label);
		}
		changeSelection();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		if (!isinCat)
		{
			for (item in grpLabel) {
				item.setPosition(item.x, item.y - 70);
			}
		}
		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if (controls.BACK)
		{
			if (!isinCat)
				FlxG.switchState(new MainMenuState());
			else
				leaveCatagory();
		}
		if (controls.ACCEPT)
		{
			if (!isinCat)
				enterCatagory();
			else {
				for (i in 0...theLinks.length) {
					if (theStuffCat[i] == curCatagory) {
						#if linux
						Sys.command('/usr/bin/xdg-open', [theLinks[curSelected + theStuffCat.indexOf(curCatagory)]], "&"]);
						#else
						FlxG.openURL(theLinks[curSelected + theStuffCat.indexOf(curCatagory)]);
						#end
					}
				}
			}
		}
	}
	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end
		trace(grpCatagories.length);
		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;
		
		if (curSelected < 0)
			curSelected = realLength - 1;
		if (curSelected >= realLength)
			curSelected = 0;


		var bullShit:Int = 0;
		for (i in 0...realLength)
		{
			grpCatagories.members[i].targetY = bullShit - curSelected;
			bullShit++;

			grpCatagories.members[i].alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (grpCatagories.members[i].targetY == 0)
			{
				grpCatagories.members[i].alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
			if (i == curSelected) {
				grpCatagories.members[i].alpha = 1;
			} else grpCatagories.members[i].alpha = 0.6;
		}
	}
	function enterCatagory()
	{
		realLength = 0;
		var order:Int = 1;
		isinCat = true;
		for (item in grpCatagories){
			grpCatagories.remove(item);
		}
		for (item in grpLabel) {
			grpLabel.remove(item);
		}
		prevSelected = curSelected;
		for (i in 0...allTheStuff.length) {
			if (theStuffCat[i] == curSelected) {
				var text:Alphabet = new Alphabet(0, (90 * order) + 30, allTheStuff[i], true, false);
				curCatagory = curSelected;
				//text.move = false;
				text.isMenuItem = true;
				text.targetY = order;
				order++;
				grpCatagories.add(text);
				realLength++;
			}
		}
		trace(grpCatagories.length);
		curSelected = 0;
		changeSelection();
	}
	function leaveCatagory()
	{
		realLength = 0;
		isinCat = false;
		for (item in grpCatagories){
			grpCatagories.remove(item);
		}
		for (item in grpLabel) {
			grpLabel.remove(item);
		}
		for (i in 0...catagories.length) {
			var catagory:Alphabet = new Alphabet(0, (90 * i) + 30, catagories[i], true, false);
			var label:Alphabet = new Alphabet(0, (90 * i) + 30, labels[i], true, false);
			//label.move = false;
			label.alpha = 0.5;
			//catagory.move = false;
			catagory.isMenuItem = true;
			catagory.targetY = i;
			grpCatagories.add(catagory);
			grpLabel.add(label);
			realLength++;
		}
		curSelected = prevSelected;
		changeSelection();
	}
}
