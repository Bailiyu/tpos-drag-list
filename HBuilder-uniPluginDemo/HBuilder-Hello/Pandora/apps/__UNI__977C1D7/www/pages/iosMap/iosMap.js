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


(()=>{var m=Object.create;var u=Object.defineProperty;var v=Object.getOwnPropertyDescriptor;var b=Object.getOwnPropertyNames;var x=Object.getPrototypeOf,y=Object.prototype.hasOwnProperty;var w=(e,t)=>()=>(t||e((t={exports:{}}).exports,t),t.exports);var C=(e,t,o,i)=>{if(t&&typeof t=="object"||typeof t=="function")for(let s of b(t))!y.call(e,s)&&s!==o&&u(e,s,{get:()=>t[s],enumerable:!(i=v(t,s))||i.enumerable});return e};var _=(e,t,o)=>(o=e!=null?m(x(e)):{},C(t||!e||!e.__esModule?u(o,"default",{value:e,enumerable:!0}):o,e));var l=w((V,g)=>{g.exports=Vue});var A=_(l());function n(e,t,...o){uni.__log__?uni.__log__(e,t,...o):console[e].apply(console,[...o,t])}var f=(e,t)=>{let o=e.__vccOpts||e;for(let[i,s]of t)o[i]=s;return o};var a=_(l()),L={"test-button-group":{"":{display:"flex",flexDirection:"row",width:"750rpx",justifyContent:"space-between",color:"#FFFFFF",paddingTop:20,paddingRight:20,paddingBottom:20,paddingLeft:20}}},k={data(){return{videoUrl:"",dataList:[]}},onLoad(e){e.videoUrl&&(this.videoUrl=e.videoUrl,n("log","at pages/iosMap/iosMap.nvue:26","videoUrl =>",this.videoUrl));let t=[];for(let o=0;o<30;o++)t.push({name_text:`\u725B\u8089\u9762\u7B2C ${o} \u7897`,img_url:"https://sandbox.tuanmanman.vip/storage/20240814/sellers/store/2024081422532866bcc4e8adcd4.png"});this.dataList=t,n("log","at pages/iosMap/iosMap.nvue:36","\u5F00\u59CB\u52A0\u8F7D\u5546\u54C1\u6E90\u6570\u636E")},methods:{cancelAction(){uni.navigateBack()},exportVideo(){this.$refs.blyVideoEdit.exportVideo()},didChangeDataList(e){n("log","at pages/iosMap/iosMap.nvue:48","\u6392\u5E8F\u6210\u529F =>",e)},complete(e){n("log","at pages/iosMap/iosMap.nvue:52","\u5BFC\u51FA\u89C6\u9891\u6210\u529F =>",e.detail),this.getOpenerEventChannel().emit("acceptDataFromOpenedPage",{data:e.detail}),uni.navigateBack({success:o=>{}})}}};function D(e,t,o,i,s,p){let d=(0,a.resolveComponent)("button"),h=(0,a.resolveComponent)("tpos-drag-list");return(0,a.openBlock)(),(0,a.createElementBlock)("scroll-view",{scrollY:!0,showScrollbar:!0,enableBackToTop:!0,bubble:"true",style:{flexDirection:"column"}},[(0,a.createElementVNode)("view",{style:{"background-color":"black",width:"100vw",height:"100%"}},[(0,a.createElementVNode)("view",{class:"test-button-group"},[(0,a.createVNode)(d,{onClick:p.cancelAction},{default:(0,a.withCtx)(()=>[(0,a.createTextVNode)("\u53D6\u6D88")]),_:1},8,["onClick"]),(0,a.createVNode)(d,{type:"primary",onClick:p.exportVideo},{default:(0,a.withCtx)(()=>[(0,a.createTextVNode)("\u5B8C\u6210")]),_:1},8,["onClick"])]),(0,a.createVNode)(h,{ref:"tposDragList",style:{width:"750rpx",height:"751px","background-color":"white"},dataList:s.dataList,onDidChangeDataList:p.didChangeDataList},null,8,["dataList","onDidChangeDataList"])])])}var r=f(k,[["render",D],["styles",[L]]]);var c=plus.webview.currentWebview();if(c){let e=parseInt(c.id),t="pages/iosMap/iosMap",o={};try{o=JSON.parse(c.__query__)}catch(s){}r.mpType="page";let i=Vue.createPageApp(r,{$store:getApp({allowDefault:!0}).$store,__pageId:e,__pagePath:t,__pageQuery:o});i.provide("__globalStyles",Vue.useCssStyles([...__uniConfig.styles,...r.styles||[]])),i.mount("#root")}})();
