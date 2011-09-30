/*
Copyright 2011 Marek Standio.

This file is part of DIY streetview player.

SaladoPlayer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published
by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

SaladoPlayer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with SaladoPlayer. If not, see <http://www.gnu.org/licenses/>.
*/
package org.diystreetview.modules.directionfixer.events{
	
	import flash.events.Event;
	
	public class ValuesDataEvent extends Event{
		
		//public static const STATE_CHANGED:String = "stateChngd";
		public static const HOTSPOTS_LOADED_CHANGED:String = "hotspotsLoadedChngd";
		
		public function ValuesDataEvent(type:String) {
			super(type);
		}
	}
}