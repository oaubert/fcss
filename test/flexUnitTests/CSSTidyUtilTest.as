package flexUnitTests
{
	import com.flashartofwar.fcss.utils.CSSTidyUtil;

	import flexunit.framework.TestCase;

	public class CSSTidyUtilTest extends TestCase
	{
		// please note that all test methods should start with 'test' and should be public

		public function get cssText():String
		{
			var xml:XML = <css><![CDATA[/* This is a comment in the CSS file */
								baseStyle {
									x: 300px;
									height: 150 px;
									margin: 0px;
								}
								
								baseStyle .SimpleButton
								{
									border: 		#ff0000;	
								}
							]]>
				</css>;
			return xml.toString();
		}

		// Reference declaration for class to test
		private var classToTestRef : com.flashartofwar.fcss.utils.CSSTidyUtil;

		public function CSSTidyUtilTest(methodName:String=null)
		{
			super(methodName);
		}

		override public function setUp():void
		{
			super.setUp();
		}

		override public function tearDown():void
		{
			super.tearDown();
		}

		public function testTidy():void
		{
			// Add your test logic here
			var tidyCSS:String = CSSTidyUtil.tidy(cssText);
			//trace(tidyCSS);
			assertEquals(tidyCSS, "baseStyle{x:300;height:150 ;margin:0;}baseStyle .SimpleButton{border:#ff0000;}");
		}
	}
}
