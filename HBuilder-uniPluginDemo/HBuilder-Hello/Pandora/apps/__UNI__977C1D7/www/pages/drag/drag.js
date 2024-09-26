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


(()=>{var h=Object.create;var l=Object.defineProperty;var m=Object.getOwnPropertyDescriptor;var y=Object.getOwnPropertyNames;var b=Object.getPrototypeOf,L=Object.prototype.hasOwnProperty;var w=(t,e)=>()=>(e||t((e={exports:{}}).exports,e),e.exports);var v=(t,e,o,r)=>{if(e&&typeof e=="object"||typeof e=="function")for(let s of y(e))!L.call(t,s)&&s!==o&&l(t,s,{get:()=>e[s],enumerable:!(r=m(e,s))||r.enumerable});return t};var c=(t,e,o)=>(o=t!=null?h(b(t)):{},v(e||!t||!t.__esModule?l(o,"default",{value:t,enumerable:!0}):o,t));var i=w((B,d)=>{d.exports=Vue});var C=c(i());function _(t,e,...o){uni.__log__?uni.__log__(t,e,...o):console[t].apply(console,[...o,e])}var g=(t,e)=>{let o=t.__vccOpts||t;for(let[r,s]of e)o[r]=s;return o};var a=c(i()),x={"test-button-group":{"":{display:"flex",flexDirection:"row",width:"750rpx",justifyContent:"space-between",color:"#FFFFFF",paddingTop:20,paddingRight:20,paddingBottom:20,paddingLeft:20}}},k={data(){return{dataList:[]}},onLoad(){this.initData()},methods:{cancelAction(){uni.navigateBack()},initData(){this.tipsTitleList=["\u5546\u54C1\u540D\u79F0","\u7F6E\u9876","\u62D6\u52A8"];let t=[];for(var e=0;e<20;e++)t.push({id:e,name_text:`\u7B2C${e}\u4E2A\u5546\u54C1`,img_url:"https://sandbox.tuanmanman.vip/storage/20240808/product/store/2024080816332466b482d466ff1.png"});this.dataList=t},didChangeDataList(t){_("log","at pages/drag/drag.nvue:39","\u6570\u636E\u6539\u53D8\u7ED3\u679C =>",t)}}};function D(t,e,o,r,s,u){let f=(0,a.resolveComponent)("tpos-drag-list");return(0,a.openBlock)(),(0,a.createElementBlock)("scroll-view",{scrollY:!0,showScrollbar:!0,enableBackToTop:!0,bubble:"true",style:{flexDirection:"column"}},[(0,a.createElementVNode)("view",{style:{"background-color":"black",width:"100vw",height:"100%"}},[s.dataList&&s.dataList.length>0?((0,a.openBlock)(),(0,a.createBlock)(f,{key:0,ref:"dragList",style:{width:"750rpx",height:"751px","background-color":"white"},dataList:s.dataList,tips:t.tipsTitleList,hideButton:!0,cellType:"gray-bg",confirmTitle:"\u4FDD\u5B58",onDid_changed:u.didChangeDataList},null,8,["dataList","tips","onDid_changed"])):(0,a.createCommentVNode)("",!0)])])}var n=g(k,[["render",D],["styles",[x]]]);var p=plus.webview.currentWebview();if(p){let t=parseInt(p.id),e="pages/drag/drag",o={};try{o=JSON.parse(p.__query__)}catch(s){}n.mpType="page";let r=Vue.createPageApp(n,{$store:getApp({allowDefault:!0}).$store,__pageId:t,__pagePath:e,__pageQuery:o});r.provide("__globalStyles",Vue.useCssStyles([...__uniConfig.styles,...n.styles||[]])),r.mount("#root")}})();
