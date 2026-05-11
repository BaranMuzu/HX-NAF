package hxnaf.util;

import Sys;
import haxe.Json;
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;
import openfl.Assets;

class DiscordUtil
{
  public static var clientID:String = "";
  public static var defaultLargeImage:String = "";
  public static var defaultLargeText:String = "";

  /**
   * Initializes the Discord RPC system and reads the JSON file.
   */
  public static function initialize():Void
  {
    var jsonPath = "assets/data/config/discord.json";

    if (Assets.exists(jsonPath))
    {
      var rawText = Assets.getText(jsonPath);

      if (rawText != null && StringTools.trim(rawText) != "")
      {
        try
        {
          var data:Dynamic = Json.parse(rawText);
          clientID = data.clientID;
          defaultLargeImage = data.largeImageKey;
          defaultLargeText = data.largeImageText;
        }
        catch (e:Dynamic)
        {
          trace("Discord JSON Error: " + e);
          return;
        }
      }
    }

    if (clientID == null || clientID == "") return;

    var handlers:DiscordEventHandlers = new DiscordEventHandlers();
    handlers.ready = cpp.Function.fromStaticFunction(onReady);
    handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
    handlers.errored = cpp.Function.fromStaticFunction(onError);

    Discord.Initialize(clientID, cpp.RawPointer.addressOf(handlers), true, "");

    sys.thread.Thread.create(() ->
    {
      while (true)
      {
        Discord.RunCallbacks();
        Sys.sleep(2);
      }
    });
  }

  /**
   * Updates the "Rich Presence" status shown on the Discord profile.
   * @param details The top line of the status (e.g., "Main Menu" or "Night 1").
   * @param state The bottom line of the status (e.g., "Har Har Har xd" or "02:00 AM").
   * @param smallImageKey The key name for the small icon (Optional).
   * @param smallImageText The text that appears when hovering over the small icon (Optional).
   */
  public static function changePresence(details:String, state:String, ?smallImageKey:String, ?smallImageText:String):Void
  {
    var discordPresence:DiscordRichPresence = new DiscordRichPresence();

    discordPresence.state = state;
    discordPresence.details = details;
    discordPresence.largeImageKey = defaultLargeImage;
    discordPresence.largeImageText = defaultLargeText;

    if (smallImageKey != null) discordPresence.smallImageKey = smallImageKey;
    if (smallImageText != null) discordPresence.smallImageText = smallImageText;

    Discord.UpdatePresence(cpp.RawPointer.addressOf(discordPresence));
  }

  /**
   * Triggered when the connection to Discord is successfully.. ready.
   */
  static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
  {
    var username:String = cast(request[0].username, String);
    var discriminator:String = cast(request[0].discriminator, String);
    var userTag = (discriminator != null && discriminator != "0" && discriminator != "0000") ? '#$discriminator' : '';

    trace('Discord RPC Connected. User: $username$userTag');
  }

  /**
   * Triggered when an error occurs during the Discord connection.
   * @param _code The error code.
   * @param _message The error message sent by Discord.
   */
  static function onError(_code:Int, _message:cpp.ConstCharStar):Void
  {
    trace("Discord Error: " + _code);
  }

  /**
   * Triggered when the connection to Discord is lost.
   * @param _code The disconnection code.
   * @param _message The disconnection message sent by Discord.
   */
  static function onDisconnected(_code:Int, _message:cpp.ConstCharStar):Void
  {
    trace("Discord Disconnected: " + _code);
  }
}
