/**
 * <p>Original Author:  jessefreeman</p>
 * <p>Class File: TypeHelperUtil.as</p>
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
 * <p>The TypeHelper converts strings into native typed values. This
 *    is useful when getting property values from XML or url request
 *    and doing converting on the fly.</p>
 *
 * <p>Revisions<br/>
 *        1.0.0  Initial version Feb 11, 2010</p>
 *
 */

package com.flashartofwar.fcss.utils
{
    import com.flashartofwar.fcss.enum.ColorsByName;

    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
    import flash.text.StyleSheet;
    import flash.utils.Dictionary;

    public class TypeHelperUtil
    {

        public static const STRING:String = "string";

        public static const NUMBER:String = "number";

        public static const BOOLEAN:String = "boolean";

        public static const ARRAY:String = "array";

        public static const DICTIONARY:String = "flash.utils::dictionary";

        public static const OBJECT:String = "object";

        public static const UINT:String = "uint";

        public static const RECTANGLE:String = "flash.geom::rectangle";

        public static const POINT:String = "flash.geom::point";

        public static const STYLE_SHEET:String = "flash.text::stylesheet";

        public static const URL_REQUEST:String = "flash.net::urlrequest";

        /**
         *
         */
        private static const FUNCTION_MAP:Object = new Object();
    {
        FUNCTION_MAP[NUMBER] = stringToNumber;
        FUNCTION_MAP[BOOLEAN] = stringToBoolean,FUNCTION_MAP[ARRAY] = stringToArray,FUNCTION_MAP[DICTIONARY] = stringToDictionary,FUNCTION_MAP[OBJECT] = stringToObject,FUNCTION_MAP[UINT] = stringToUint,FUNCTION_MAP[RECTANGLE] = stringToRectangle,FUNCTION_MAP[POINT] = stringToPoint,FUNCTION_MAP[STYLE_SHEET] = stringToStyleSheet,FUNCTION_MAP[URL_REQUEST] = stringToUrlRequest;
    }

        /**
         * <p>This method allows you to register other functions to handle types
         * this utility is not set up to convert.</p>
         */
        public static function registerFunction(name:String, funct:Function):void
        {
            FUNCTION_MAP[name] = funct;
        }

        /**
         *
         */
        public static function removeFunction(name:String):void
        {
            delete FUNCTION_MAP[name];
        }

        /**
         * <p>This function handles converting the data into the supplied type.</p>
         *
         *    <p>This function also has a special default function call when
         *    unknown_type_handler is set. To use this supply a function to call
         *    when the helper class doesn't know what to convert the data to.</p>
         *
         *    <p>The unknown_type_handler should accept data and type. This allows
         *    you to customize the class and extend its functionality on the fly
         *    without having to directly extend and override the main switch logic.</p>
         *
         *    @param data String representing the value that needs to be
         *    converted.
         *    @param type String representing the type the data should be
         *    converted into. Accepts string, number, array, boolean, associate
         *    array, dictionary, object, color and hex color.
         *    @return Converted data typed to supplied type value.
         *
         */
        public static function getType(data:String, type:String):*
        {
            return FUNCTION_MAP[type] ? FUNCTION_MAP[type](data) : data;
        }

        public static function stringToNumber(value:String):Number
        {
            return Number(value);
        }

        /**
         * By default this method is set up to convert CSS style arrays delimited by spaces.
         */
        public static function stringToArray(value:String, delimiter:String = " "):Array
        {
            return value.split(delimiter);
        }

        public static function splitTypeFromSource(value:String):Object
        {
            var obj:Object = new Object();
            // Pattern to strip out ',", and ) from the string;
            var pattern:RegExp = RegExp(/[\'\)\"]/g); // this fixes a color highlight issue in FDT --> '
            // Fine type and source
            var split:Array = value.split("(");
            //
            obj.type = split[0];
            obj.source = split[1].replace(pattern, "");

            return obj;
        }

        /**
         *
         */
        public static function stringToDictionary(value:String):Dictionary
        {
            return stringToComplexArray(value, DICTIONARY);
        }

        public static function stringToObject(value:String):Object
        {
            return stringToComplexArray(value, OBJECT);
        }

        /**
         * <p>This function parses out a complex array and puts it into an Associate
         * Array, Dictionary, or Object. Use this function to split up the array base
         * on the dataDelimiter (default ",") and the propDelimiter (default ":").</p>
         *
         * <p>Example of a data: "up:play,over:playO,down:playO,off_up:pause,off_over:pauseO,off_down:pauseO"</p>
         *
         */
        protected static function stringToComplexArray(data:String, returnType:String, dataDelimiter:String = ",", propDelimiter:String = ":"):*
        {

            var dataContainer:*;

            // Determine what type of object to return
            switch (returnType)
            {
                case DICTIONARY:
                    dataContainer = new Dictionary();
                    break;
                case OBJECT:
                    dataContainer = {};
                    break;
                default:
                    dataContainer = [];
            }

            var list:Array = data.split(dataDelimiter);
            var total:Number = list.length;

            for (var i:Number = 0; i < total; i++)
            {
                var prop:Array = list[i].split(propDelimiter);
                dataContainer[prop[0]] = prop[1];
            }

            return dataContainer;
        }

        /**
         * <p>Converts a string to a boolean.</p>
         */
        public static function stringToBoolean(value:String):Boolean
        {
            return (value == "true") ? true : false;
        }

        /**
         * <p>Converts a string into a uint. This function also supports converting
         * colors into .</p>
         */
        public static function stringToUint(value:String):uint
        {
            // Check to see if it is a registered color
            if (ColorsByName.isSupported(value))
            {
                return ColorsByName.convertColor(value);
            }
            else
            {
                value = value.substr(-6, 6);
                var color:uint = Number("0x" + value);
                return color;
            }
        }

        /**
         * <p>Converts rgb to hex.</p>
         *
         */
        public static function rgbToHex(r:Number, g:Number, b:Number):Number
        {
            return r << 16 | g << 8 | b;
        }

        /**
         * <p>Use this to turn Yes No values into True or False.</p>
         *
         *    @param value Accepts "yes" for true or "no" for false.
         */
        public static function stringYesNoToBoolean(value:String):Boolean
        {
            if (value.toLowerCase() == "yes")
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /**
         *
         * @param value
         * @param delimiter
         * @return
         *
         */
        public static function stringToRectangle(value:String, delimiter:String = " "):Rectangle
        {
            var coords:Array = splitTypeFromSource(value).source.split(delimiter, 4);

            if ((value == "") || (coords.length != 4))
            {
                return null;
            }
            else
            {
                return new Rectangle(coords[0], coords[1], coords[2], coords[3]);
            }
        }

        /**
         *
         * @param value
         * @param delimiter
         * @return
         *
         */
        public static function stringToPoint(value:String, delimiter:String = " "):Point
        {
            var coords:Array = splitTypeFromSource(value).source.split(delimiter, 2);
            return new Point(Number(coords[0]), Number(coords[1]));
        }

        /**
         *
         * @param value
         * @return
         *
         */
        public static function stringToStyleSheet(value:String):StyleSheet
        {

            var styleSheet:StyleSheet = new StyleSheet();
            styleSheet.parseCSS(value);
            return styleSheet;
        }

        public static function stringToUrlRequest(value:String):URLRequest
        {
            return new URLRequest(splitTypeFromSource(value).source);
        }
    }
}

