package httpcontrol
{
	import control.Loading;
	
	import mx.controls.Alert;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.AbstractOperation;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import util.LoadingUtil;

	public class RemoteUtil
	{
		private static var remoteObject:RemoteObject=new RemoteObject("service");
		private static var isInit:Boolean=false;
		public function RemoteUtil()
		{
			
		}
		
		public static function init():void{
			var channel:AMFChannel = new AMFChannel("pyamf-channel", "/oa/geteway/");
			var channels:ChannelSet = new ChannelSet();
			channels.addChannel(channel);
			
			remoteObject.showBusyCursor = true;
			remoteObject.channelSet = channels;
			remoteObject.addEventListener(FaultEvent.FAULT, faultEvent);
			remoteObject.addEventListener(ResultEvent.RESULT,resultEvent);
		}
		
		public static function getOperation(method:String):AbstractOperation{
			if(!isInit){
				init();
				isInit=true;
			}
			var op:AbstractOperation= remoteObject.getOperation(method);
			op.addEventListener(ResultEvent.RESULT,resultEvent);
			op.addEventListener(FaultEvent.FAULT,faultEvent);
			return op;
		}
		
//		public static function send(op:AbstractOperation,... args:Array):void{
//			openLoading();
//			op.send(args);
//		}
		
		public static function faultEvent(e:FaultEvent):void{
			loading.showOut();
//			Alert.show(e.fault.message,"警告");
			
			Alert.show("系统错误。","警告");
		}
		
		public static function resultEvent(e:ResultEvent):void{
//			trace(e.result.toString());
			var result:Object=e.result;
			if(result.success==false){
				Alert.show(result.message,"警告");
			}
			loading.showOut();
		}
		private static var _loading:Loading;
		
		public static function get loading():Loading
		{
			if(LoadingUtil.loading==null){
				throw "没有遮罩层……";
			}
			return LoadingUtil.loading;
			//			return _loading;
		}
		
		public static function openLoading():void{
			loading.showIn();
		}
	}
}