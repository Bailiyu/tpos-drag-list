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


(()=>{var h=Object.create;var g=Object.defineProperty;var _=Object.getOwnPropertyDescriptor;var m=Object.getOwnPropertyNames;var y=Object.getPrototypeOf,w=Object.prototype.hasOwnProperty;var b=(e,o)=>()=>(o||e((o={exports:{}}).exports,o),o.exports);var x=(e,o,t,n)=>{if(o&&typeof o=="object"||typeof o=="function")for(let a of m(o))!w.call(e,a)&&a!==t&&g(e,a,{get:()=>o[a],enumerable:!(n=_(o,a))||n.enumerable});return e};var v=(e,o,t)=>(t=e!=null?h(y(e)):{},x(o||!e||!e.__esModule?g(t,"default",{value:e,enumerable:!0}):t,e));var l=b((D,f)=>{f.exports=Vue});var O=v(l());function c(e){return weex.requireModule(e)}function i(e,o,...t){uni.__log__?uni.__log__(e,o,...t):console[e].apply(console,[...t,o])}var d=(e,o)=>{let t=e.__vccOpts||e;for(let[n,a]of o)t[n]=a;return t};var r=v(l()),E=c("VideoCutModule"),k=c("globalEvent"),u=getApp({allowDefault:!0}),P={onLoad(e){u=getApp({allowDefault:!0}),this.height=u.globalData.screenHeight,this.width=u.globalData.screenWidth;let o=this.getOpenerEventChannel();e!=null&&k.addEventListener("myEvent",t=>{if(t.data==null||t.data==""){uni.navigateBack({success:()=>{}});return}let n=t.data;i("log","at pages/common/choose-video-for-native.nvue:32","myEvent:",JSON.stringify(t)),i("log","at pages/common/choose-video-for-native.nvue:33","uni.navigateBack(",t.data),uni.navigateBack({success:()=>{o.emit("acceptDataFromOpenedPage",n)}}),i("log","at pages/common/choose-video-for-native.nvue:40","myEvent:",JSON.stringify(t))}),i("log","at pages/common/choose-video-for-native.nvue:45","options:",JSON.stringify(e)),i("log","at pages/common/choose-video-for-native.nvue:46","options:",e.filePath),E.cutVideo(e.filePath,t=>{i("log","at pages/common/choose-video-for-native.nvue:49",t)})},data(){return{filePath:"",height:0,width:0}},methods:{}};function N(e,o,t,n,a,S){return(0,r.openBlock)(),(0,r.createElementBlock)("scroll-view",{scrollY:!0,showScrollbar:!0,enableBackToTop:!0,bubble:"true",style:{flexDirection:"column"}},[(0,r.createElementVNode)("view",{style:(0,r.normalizeStyle)("height:"+a.height+"px;width:"+a.width+"px;background-color: black;")},null,4)])}var s=d(P,[["render",N]]);var p=plus.webview.currentWebview();if(p){let e=parseInt(p.id),o="pages/common/choose-video-for-native",t={};try{t=JSON.parse(p.__query__)}catch(a){}s.mpType="page";let n=Vue.createPageApp(s,{$store:getApp({allowDefault:!0}).$store,__pageId:e,__pagePath:o,__pageQuery:t});n.provide("__globalStyles",Vue.useCssStyles([...__uniConfig.styles,...s.styles||[]])),n.mount("#root")}})();
