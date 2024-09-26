"use weex:vue";

if (typeof Promise !== 'undefined' && !Promise.prototype.finally) {
  Promise.prototype.finally = function(callback) {
    const promise = this.constructor
    return this.then(
      value => promise.resolve(callback()).then(() => value),
      reason => promise.resolve(callback()).then(() => {
        throw reason
      })
    )
  }
};

if (typeof uni !== 'undefined' && uni && uni.requireGlobal) {
  const global = uni.requireGlobal()
  ArrayBuffer = global.ArrayBuffer
  Int8Array = global.Int8Array
  Uint8Array = global.Uint8Array
  Uint8ClampedArray = global.Uint8ClampedArray
  Int16Array = global.Int16Array
  Uint16Array = global.Uint16Array
  Int32Array = global.Int32Array
  Uint32Array = global.Uint32Array
  Float32Array = global.Float32Array
  Float64Array = global.Float64Array
  BigInt64Array = global.BigInt64Array
  BigUint64Array = global.BigUint64Array
};


(()=>{var f=Object.create;var u=Object.defineProperty;var m=Object.getOwnPropertyDescriptor;var x=Object.getOwnPropertyNames;var y=Object.getPrototypeOf,H=Object.prototype.hasOwnProperty;var w=(e,t)=>()=>(t||e((t={exports:{}}).exports,t),t.exports);var k=(e,t,i,a)=>{if(t&&typeof t=="object"||typeof t=="function")for(let r of x(t))!H.call(e,r)&&r!==i&&u(e,r,{get:()=>t[r],enumerable:!(a=m(t,r))||a.enumerable});return e};var v=(e,t,i)=>(i=e!=null?f(y(e)):{},k(t||!e||!e.__esModule?u(i,"default",{value:e,enumerable:!0}):i,e));var d=w((U,h)=>{h.exports=Vue});var B=v(d());function s(e,t,...i){uni.__log__?uni.__log__(e,t,...i):console[e].apply(console,[...i,t])}var _=(e,t)=>{let i=e.__vccOpts||e;for(let[a,r]of t)i[a]=r;return i};var o=v(d()),C={"test-button-group":{"":{display:"flex",flexDirection:"row",width:"750rpx",height:"100rpx",justifyContent:"space-between",color:"#FFFFFF",paddingTop:20,paddingRight:20,paddingBottom:20,paddingLeft:20}},"top-button":{"":{width:"140rpx",height:"60rpx",lineHeight:"60rpx",borderRadius:"40rpx",backgroundColor:"#f6f6f6",fontWeight:"bold",color:"#121212",textAlign:"center"}},"save-button":{"":{backgroundColor:"#ffcc01"}}},n,D={data(){return{videoUrl:"",statusbarHeight:0,navHeight:0,videoHeight:0,screenHeight:0}},onLoad(e){n=getApp({allowDefault:!0}),e.videoUrl&&(this.videoUrl=e.videoUrl,s("log","at pages/v2_pages/home/video-editor/video-editor.nvue:37","videoUrl =>",this.videoUrl)),plus.webview.currentWebview().setStyle({popGesture:"none"}),this.statusbarHeight=n.globalData.statusBarHeight,this.navHeight=n.globalData.navHeight,s("log","at pages/v2_pages/home/video-editor/video-editor.nvue:47","statusbarHeight =>",this.statusbarHeight),s("log","at pages/v2_pages/home/video-editor/video-editor.nvue:48","navHeight =>",this.navHeight),this.screenHeight=n.globalData.screenHeight,this.videoHeight=n.globalData.screenHeight-n.globalData.navHeight-n.globalData.tabHeight},methods:{cancelAction(){uni.navigateBack()},exportVideo(){this.$refs.blyVideoEdit.exportVideo()},complete(e){s("log","at pages/v2_pages/home/video-editor/video-editor.nvue:63","\u5BFC\u51FA\u89C6\u9891\u6210\u529F =>",e.detail),this.getOpenerEventChannel().emit("acceptDataFromOpenedPage",{data:e.detail}),uni.navigateBack({success:i=>{}})}}};function V(e,t,i,a,r,l){let b=(0,o.resolveComponent)("tmm-video-editor");return(0,o.openBlock)(),(0,o.createElementBlock)("scroll-view",{scrollY:!0,showScrollbar:!0,enableBackToTop:!0,bubble:"true",style:{flexDirection:"column"}},[(0,o.createElementVNode)("view",{style:(0,o.normalizeStyle)("background-color: black;width: 750rpx;height: "+r.screenHeight+"px;")},[(0,o.createElementVNode)("view",{class:"test-button-group",style:(0,o.normalizeStyle)("padding-top: "+r.statusbarHeight+"px;height:"+r.navHeight+"px;")},[(0,o.createElementVNode)("u-text",{class:"top-button",onClick:t[0]||(t[0]=(...g)=>l.cancelAction&&l.cancelAction(...g))},"\u53D6\u6D88"),(0,o.createElementVNode)("u-text",{class:"top-button save-button",onClick:t[1]||(t[1]=(...g)=>l.exportVideo&&l.exportVideo(...g))},"\u4FDD\u5B58")],4),(0,o.createElementVNode)("view",null,[(0,o.createVNode)(b,{ref:"blyVideoEdit",style:(0,o.normalizeStyle)("margin-top:10px; width: 750rpx;height:"+r.videoHeight+"px;background-color: black;"),onComplete:l.complete,videoUrl:r.videoUrl},null,8,["style","onComplete","videoUrl"])])],4)])}var p=_(D,[["render",V],["styles",[C]]]);var c=plus.webview.currentWebview();if(c){let e=parseInt(c.id),t="pages/v2_pages/home/video-editor/video-editor",i={};try{i=JSON.parse(c.__query__)}catch(r){}p.mpType="page";let a=Vue.createPageApp(p,{$store:getApp({allowDefault:!0}).$store,__pageId:e,__pagePath:t,__pageQuery:i});a.provide("__globalStyles",Vue.useCssStyles([...__uniConfig.styles,...p.styles||[]])),a.mount("#root")}})();
