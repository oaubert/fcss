
/** 
 * <p>Original Author:  jessefreeman</p>
 * <p>Class File: StyleSheetCollection.as</p>
 * 
 * <p>Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:</p>
 * 
 * <p>The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.</p>
 * 
 * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 * 
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 *
 * <p>Revisions<br/> 
 *		1.0  Initial version Aug 28, 2009</p>
 *
 */

package com.flashartofwar.fcss.stylesheets {
	import flash.utils.Dictionary;
	import com.flashartofwar.fcss.styles.Style;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;

	public class StyleSheetCollection
	{

		public var styleSheets : Dictionary = new Dictionary(true);

		/**
		 * 
		 * @param enforcer
		 * 
		 */		
		public function StyleSheetCollection() 
		{
		}

		/**
		 * 
		 * @param selectorName
		 * @return 
		 * 
		 */		
		public function getSelector( ... selectorNames) : Style
		{
			var tempProperties : Style = new Style( );
			
			for each (var styleSheet:IStyleSheet in styleSheets)
			{
				var sheetProperties : Style = styleSheet.getSelector.apply( null, selectorNames );
				if(sheetProperties.selectorName != "EmptyProperties")
					tempProperties.merge( sheetProperties );	
			}
			
			return tempProperties; 
		}

		/**
		 * 
		 * @param id
		 * @param sheet
		 * 
		 */		
		public function addStyleSheet(id : String, sheet : IStyleSheet) : void
		{
			styleSheets[id] = sheet;
		}

		/**
		 * 
		 * @param id
		 */
		public function getStyleSheet(id : String) : IStyleSheet
		{
			return styleSheets[id];	
		}

		/**
		 * 
		 * @param id
		 * 
		 */		
		public function removeStyleSheet(id : String) : void
		{
			styleSheets[id] = null;
			delete styleSheets[id];
		}

	}
}