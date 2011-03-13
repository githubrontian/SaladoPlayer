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
package com.panozona.player.manager.utils.configuration{
	
	import com.panozona.player.manager.utils.loading.ILoadable;
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.*;
	import com.panozona.player.manager.data.actions.*;
	import com.panozona.player.manager.data.panoramas.*;
	import com.panozona.player.manager.events.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class ManagerDataValidator extends EventDispatcher{
		
		public function validate(managerData:ManagerData):void {
			checkGlobal(managerData);
			checkPanoramas(managerData);
			checkHotspots(managerData);
			checkModules(managerData);
			checkActions(managerData);
		}
		
		protected function checkGlobal(managerData:ManagerData):void {
			actionExists(managerData.allPanoramasData.firstOnEnter, managerData);
			actionExists(managerData.allPanoramasData.firstOnTransitionEnd, managerData);
			panoramaExists(managerData.allPanoramasData.firstPanorama, managerData);
		}
		
		protected function checkPanoramas(managerData:ManagerData):void {
			if (managerData.panoramasData.length < 1) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
					"No panoramas found."));
				return;
			}
			var panoramasId:Object = new Object();
			
			for each(var panoramaData:PanoramaData in managerData.panoramasData) {
				if (panoramaData.id == null) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missig panorama id."));
					continue;
				}
				if (panoramaData.params.path == null) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missig panorama path."));
					continue;
				}
				if (panoramasId[panoramaData.id] != undefined) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Repeating panorama id: " + panoramaData.id));
					continue;
				}
				panoramasId[panoramaData.id] = ""; // not undefined
				
				actionExists(panoramaData.onEnter, managerData);
				actionExists(panoramaData.onLeave, managerData);
				actionExists(panoramaData.onTransitionEnd, managerData);
				checkActionTrigger(panoramaData.id, panoramaData.onEnterFrom, managerData);
				checkActionTrigger(panoramaData.id, panoramaData.onTransitionEndFrom, managerData);
				checkActionTrigger(panoramaData.id, panoramaData.onLeaveTo, managerData);
				checkActionTrigger(panoramaData.id, panoramaData.onLeaveToAttempt, managerData);
			}
		}
		
		protected function checkHotspots(managerData:ManagerData):void {
			var factoryFound:Boolean;
			var moduleData:ModuleData;
			var hotspotsId:Object = new Object();
			for each(var panoramaData:PanoramaData in managerData.panoramasData) {
				for each(var hotspotData:HotspotData in panoramaData.hotspotsData) {
					if (hotspotData.id == null) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
							"Missig hotspot id."));
						continue;
					}
					if (hotspotsId[hotspotData.id] != undefined) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, 
							"Repeating hotspot id: " + hotspotData.id));
						continue;
					}
					hotspotsId[hotspotData.id] = ""; // not undefined
					
					actionExists(hotspotData.mouse.onClick, managerData);
					actionExists(hotspotData.mouse.onOut, managerData);
					actionExists(hotspotData.mouse.onOver, managerData);
					actionExists(hotspotData.mouse.onPress, managerData);
					actionExists(hotspotData.mouse.onRelease, managerData);
					
					if ((hotspotData is HotspotDataImage) || (hotspotData is HotspotDataSwf)) {
						if ((hotspotData as ILoadable).path == null) {
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
								"Missig hotspot path: " + hotspotData.id));
							continue;
						}
					}else if (hotspotData is HotspotDataFactory) {
						moduleData = managerData.getModuleDataByName((hotspotData as HotspotDataFactory).factory);
						if (!(moduleData is ModuleDataFactory)){
								dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
									"Invalid factory name in hotspot: "+ hotspotData.id));
								continue;
						}
					}
				}
			}
		}
		
		protected function actionExists(actionId:String, managerData:ManagerData):void {
			if (actionId != null && managerData.getActionDataById(actionId) == null)
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
					"Action not found: " + actionId));
		}
		
		protected function checkActionTrigger(panoramaId:String, actionTrigger:Object, managerData:ManagerData):void {
			for (var checkedPanoramaId:String in actionTrigger) {
				panoramaExists(checkedPanoramaId, managerData);
				actionExists(actionTrigger[checkedPanoramaId], managerData);
				if (panoramaId == checkedPanoramaId) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Same panorama id not allowed: " + panoramaId));
				}
			}
		}
		
		protected function panoramaExists(panoramaId:String, managerData:ManagerData):void{
			if (panoramaId != null && managerData.getPanoramaDataById(panoramaId) == null)
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
					"Panorama not found: " + panoramaId));
		}
		
		protected function checkModules(managerData:ManagerData):void {
			var modulesName:Object = new Object();
			var hotspotDataFactoryFound:Boolean;
			for each(var moduleData:ModuleData in managerData.modulesData) {
				if (moduleData.name == null) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missig module id."));
					continue;
				}
				if (moduleData.path == null) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missig path in: " + moduleData.name));
					continue;
				}
				if (moduleData.descriptionReference == null) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missig description for: " + moduleData.name));
					continue
				}
				if (modulesName[moduleData.name] != undefined) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Repeating name: " + moduleData.name));
					continue;
				}
				modulesName[moduleData.name] = ""; // not undefined
				if (moduleData is ModuleDataFactory) {
					for (var hotspotId:String in (moduleData as ModuleDataFactory).definition) {
						hotspotDataFactoryFound = false;
						p: for each(var panoramaData:PanoramaData in managerData.panoramasData) {
							for each (var hotspotDataFactory:HotspotDataFactory in panoramaData.getHotspotsFactory()){
								if (hotspotDataFactory.id == hotspotId) {
									hotspotDataFactoryFound = true;
									if (hotspotDataFactory.factory != moduleData.name) {
										dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
											"Hotspot points do another factory: " + hotspotId));
									}
									break p;
								}
							}
						}
						if (!hotspotDataFactoryFound) {
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
								"Unknown hotspot in definition: " + hotspotId));
						}
					}
				}
			}
		}
		
		protected function checkActions(managerData:ManagerData):void {
			var actionsId:Object = new Object();
			for each(var actionData:ActionData in managerData.actionsData) {
				if (actionData.id == null) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missig action id."));
					continue;
				}
				if (actionsId[actionData.id] != undefined) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Repeating action id: " + actionData.id));
					continue;
				}
				actionsId[actionData.id] = ""; // not undefined
				for each(var functionData:FunctionData in actionData.functions) {
					checkFunction(functionData, managerData);
				}
			}
		}
		
		protected function checkFunction(functionData:FunctionData, managerData:ManagerData):void {
			if (managerData.getModuleDataByName(functionData.owner) == null) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Owner not found: " + functionData.owner + "." + functionData.name));
				return;
			}
			if (managerData.getModuleDataByName(functionData.owner).descriptionReference != null) {
				verifyFunction(functionData, managerData);
			}
		}
		
		protected function verifyFunction(functionData:FunctionData, managerData:ManagerData):void {
			var moduleDescription:ModuleDescription = managerData.getModuleDataByName(functionData.owner).descriptionReference;
			var hotspotDataFactoryFound:Boolean;
			if (moduleDescription.functionsDescription[functionData.name] == undefined) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Function not found: " + functionData.owner + "." + functionData.name));
				return;
			}
			if ((moduleDescription.functionsDescription[functionData.name] as Vector.<Class>).length != functionData.args.length) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Wrong number of arguments in: " +
					functionData.owner + "." + functionData.name +
					" got: " + functionData.args.length +
					" expected: " + (moduleDescription.functionsDescription[functionData.name] as Vector.<Class>).length));
				return;
			}
			if (functionData is FunctionDataFactory ) {
				for each(var hotspotId:String in (functionData as FunctionDataFactory).targets) {
					hotspotDataFactoryFound = false;
					p: for each (var panoramaData:PanoramaData in managerData.panoramasData) {
						for each (var hotspotDataFactory:HotspotDataFactory in panoramaData.getHotspotsFactory()) {
							if (hotspotDataFactory.id == hotspotId) {
								hotspotDataFactoryFound = true;
								break p;
							}
						}
					}
					if (!hotspotDataFactoryFound) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
							"Target not found: " + functionData.owner + "[" + hotspotId + "]." + functionData.name));
						return;
					}
				}
			}
			if ((moduleDescription.functionsDescription[functionData.name] as Vector.<Class>).length > 0){
				for (var i:uint = 0; i < functionData.args.length; i++) {
					if (!(functionData.args[i] is (moduleDescription.functionsDescription[functionData.name] as Vector.<Class>)[i])) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Wrong argument type in: " +
							moduleDescription.name + "." + functionData.name +
							" got: " + functionData.args[i] +
							" expected: " + getQualifiedClassName((moduleDescription.functionsDescription[functionData.name] as Vector.<Class>)[i]).match(/[^:]+$/)[0]));
						return;
					}
				}
			}
		}
	}
}