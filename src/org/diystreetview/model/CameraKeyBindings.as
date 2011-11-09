/*
Copyright 2010 Zephyr Renner.

This file is part of PanoSalado.

PanoSalado is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

PanoSalado is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PanoSalado. If not, see <http://www.gnu.org/licenses/>.
*/
package org.diystreetview.model {
	
	import flash.ui.Keyboard;
	
	final public class CameraKeyBindings{
		public static const UP:uint = Keyboard.F14;
		public static const DOWN:uint = Keyboard.F15;
		public static const LEFT:uint = Keyboard.LEFT;
		public static const RIGHT:uint = Keyboard.RIGHT;
		public static const IN:uint = Keyboard.SHIFT;
		public static const OUT:uint = Keyboard.CONTROL;
		
		public static const FORWARD:uint  = Keyboard.UP;
		public static const BACKWARD:uint = Keyboard.DOWN;
	}
}