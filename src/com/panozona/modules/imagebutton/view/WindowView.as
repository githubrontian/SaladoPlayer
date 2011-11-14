﻿/*
Copyright 2011 Marek Standio.

This file is part of SaladoPlayer.

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
package com.panozona.modules.imagebutton.view{
	
	import com.panozona.modules.imagebutton.model.ImageButtonData;
	import com.panozona.modules.imagebutton.model.structure.Button;
	import com.panozona.modules.imagebutton.model.WindowData;
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var _buttonView:ButtonView;
		private var _windowData:WindowData;
		
		public function WindowView(windowData:WindowData):void {
			
			_windowData = windowData;
			
			this.alpha = _windowData.window.alpha;
			
			_buttonView = new ButtonView(_windowData);
			addChild(_buttonView);
			
			visible = _windowData.open;
		}
		
		public function get windowData():WindowData {
			return _windowData;
		}
		
		public function get buttonView():ButtonView {
			return _buttonView;
		}
	}
}