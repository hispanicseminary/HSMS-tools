function Hilitor2(id,tag){
var targetNode=document.getElementById(id)||document.body;
var hiliteTag=tag||"MATCH";
var skipTags=new RegExp("^(?:"+hiliteTag+"|SCRIPT|FORM)$");
var colors=["cyan","cyan","cyan","cyan","cyan","cyan","cyan","cyan","cyan","cyan","cyan","cyan"];
var wordColor=[];
var colorIdx=0;
var matchRegex="";
var openLeft=false;
var openRight=false;

this.setMatchType=function(type){
	switch(type){
		case"left":this.openLeft=false;
			this.openRight=true;
			break;
		case"right":this.openLeft=true;
			this.openRight=false;
			break;
		case"open":this.openLeft=this.openRight=true;
			break;
		default:this.openLeft=this.openRight=false;
	}
};

function addAccents(input){
	retval=input;
//	retval=retval.replace(/([ao])e/ig,"$1");
//	retval=retval.replace(/\\u00E[024]/ig,"a");
//	retval=retval.replace(/\\u00E7/ig,"c");
//	retval=retval.replace(/\\u00E[89AB]/ig,"e");
//	retval=retval.replace(/\\u00E[EF]/ig,"i");
//	retval=retval.replace(/\\u00F[46]/ig,"o");
//	retval=retval.replace(/\\u00F[9BC]/ig,"u");
//	retval=retval.replace(/\\u00FF/ig,"y");
//	retval=retval.replace(/\\u00DF/ig,"s");
//	retval=retval.replace(/a/ig,"([aàâäá]|ae)");
//	retval=retval.replace(/s/ig,"(ss|[sß])");
	retval=retval.replace(/\'/ig,"([”’])");
	retval=retval.replace(/a/ig,"([aàâäá])");
	retval=retval.replace(/e/ig,"[eèéêë]");
	retval=retval.replace(/i/ig,"[iîïí]");
	retval=retval.replace(/o/ig,"([oôöó]|oe)");
	retval=retval.replace(/u/ig,"[uùûüú]");
	retval=retval.replace(/b/ig,"[bBƀḇḅɃḆḄ]");
	retval=retval.replace(/c/ig,"[cCćĉčċçĆĈĊČÇ]");
	retval=retval.replace(/d/ig,"[dDđḍĐḌ]");
	retval=retval.replace(/g/ig,"[gGǵĝǧġǥĜǦĠǤ]");
	retval=retval.replace(/h/ig,"[hHħḥĦḤ]");
	retval=retval.replace(/j/ig,"[jJĵǰĴ]");
	retval=retval.replace(/l/ig,"[lLŀļĿ]");
	retval=retval.replace(/n/ig,"[ñn]");
	retval=retval.replace(/q/ig,"[qQ]");
	retval=retval.replace(/r/ig,"[rR]");
	retval=retval.replace(/s/ig,"[sSśŝšşʂŚŜŠŞ]");
	retval=retval.replace(/v/ig,"[vVṿṾ]");
	retval=retval.replace(/x/ig,"[xX]");
	retval=retval.replace(/y/ig,"[yYỳŷỲŶ]");
	retval=retval.replace(/z/ig,"[zZźẑžʐŹŽẐ]");
	return retval;
}

this.setRegex=function(input){
	input=input.replace(/\\([^u]|$)/g,"$1");
	input=input.replace(/[^\w\\\s']+/g,"").replace(/\s+/g,"|");
	input=addAccents(input);
	var re="("+input+")";
	if(!this.openLeft)re="(?:^|[\\b\\s])"+re;
	if(!this.openRight)re=re+"(?:[\\b\\s]|$)";
	matchRegex=new RegExp(re,"i");
};

this.getRegex=function() {
	var retval=matchRegex.toString();
	retval=retval.replace(/(^\/|\(\?:[^\)]+\)|\/i$)/g,"");
	return retval;
};

this.hiliteWords=function(node){
	if(node===undefined||!node)return;
	if(!matchRegex)return;
	if(skipTags.test(node.nodeName))return;
	if(node.hasChildNodes()){
		for(var i=0;i<node.childNodes.length;i++) {
			this.hiliteWords(node.childNodes[i]);
		}
	}
	if(node.nodeType==3){
		if((nv=node.nodeValue)&&(regs=matchRegex.exec(nv))){
			if(!wordColor[regs[1].toLowerCase()]){wordColor[regs[1].toLowerCase()]=colors[colorIdx++%colors.length];}
			var match=document.createElement(hiliteTag);
			match.appendChild(document.createTextNode(regs[1]));
			match.style.backgroundColor= wordColor[regs[1].toLowerCase()];//'Cyan';
			match.style.fontStyle="inherit";
			match.style.color="inherit";
			var after;
			if(regs[0].match(/^\s/)){after=node.splitText(regs.index+1);}else{after=node.splitText(regs.index);}
			after.nodeValue=after.nodeValue.substring(regs[1].length);
			node.parentNode.insertBefore(match,after);
		}
	};
};

this.remove=function() {
	var arr=document.getElementsByTagName(hiliteTag);
	while(arr.length&&(el=arr[0])){
		var parent=el.parentNode;
		parent.replaceChild(el.firstChild,el);
		parent.normalize();
	}
};

this.apply=function(input){
	this.remove();
	if(input===undefined||!(input=input.replace(/(^\s+|\s+$)/g,"")))return;
	input=convertCharStr2jEsc(input);
	this.setRegex(input);
	this.hiliteWords(targetNode);
};

function dec2hex4(textString){
	var hexequiv=new Array("0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F");
	return hexequiv[(textString>>12)&0xF]+hexequiv[(textString>>8)&0xF]+hexequiv[(textString>>4)&0xF]+hexequiv[textString&0xF];
}

function convertCharStr2jEsc(str,cstyle){
	var highsurrogate=0;
	var suppCP;
	var pad;
	var n=0;
	var outputString='';
	for(var i=0;i<str.length;i++){
		var cc=str.charCodeAt(i);
		if(cc<0||cc>0xFFFF){outputString+='!Error in convertCharStr2UTF16: unexpected charCodeAt result, cc='+cc+'!';}
		if(highsurrogate!=0){
			if(0xDC00<=cc&&cc<=0xDFFF){
				suppCP=0x10000+((highsurrogate-0xD800)<<10)+(cc-0xDC00);
				if(cstyle){
					pad=suppCP.toString(16);
					while(pad.length<8){pad='0'+pad;}
					outputString+='\\U'+pad;
				}
				else{suppCP-=0x10000; outputString+='\\u'+dec2hex4(0xD800|(suppCP>>10))+'\\u'+dec2hex4(0xDC00|(suppCP&0x3FF));}
				highsurrogate=0;
				continue;
			}
			else{outputString+='Error in convertCharStr2UTF16: low surrogate expected, cc='+cc+'!';	highsurrogate=0;}
		}
		if(0xD800<=cc&&cc<=0xDBFF){
			highsurrogate=cc;
		}
		else{
			switch(cc){
				case 0:outputString+='\\0';
				break;
				case 8:outputString+='\\b';
				break;
				case 9:outputString+='\\t';
				break;
				case 10:outputString+='\\n';
				break;
				case 13:outputString+='\\r';
				break;
				case 11:outputString+='\\v';
				break;
				case 12:outputString+='\\f';
				break;
				case 34:outputString+='\\\"';
				break;
				case 39:outputString+='\\\'';
				break;
				case 92:outputString+='\\\\';
				break;
				default:if(cc>0x1f&&cc<0x7F){outputString+=String.fromCharCode(cc);}
				else{
					pad=cc.toString(16).toUpperCase();
					while(pad.length<4){pad='0'+pad;}
					outputString+='\\u'+pad;
				}
			}
		}
	}
	return outputString;
}

}

var myHilitor;
var matchIndex=-1;
var matchArr=[];
var container=document.getElementById("content");
var searchEl=document.getElementById("keywords");
var counterEl=document.getElementById("counter");
var navEl=document.getElementById("navigate");
var navPre=document.getElementById("prev");
var navNext=document.getElementById("next");
var navCancel=document.getElementById("cancel");
var regexEl=document.getElementById("regex")

document.addEventListener("DOMContentLoaded",function(){
	myHilitor=new Hilitor2("content");
	myHilitor.setMatchType("left");
},false);

var searchTrigger=function(){
	myHilitor.apply(searchEl.value);
	regexEl.innerHTML="Regex: "+myHilitor.getRegex();
	doStuff();
}

document.getElementById("keywords").addEventListener("keyup",searchTrigger,false);

navPre.addEventListener("click",function(e){
	doNav(-1);
	e.preventDefault();
},false);

navNext.addEventListener("click",function(e){
	doNav(1);
	e.preventDefault();
},false);

navCancel.addEventListener("click",function(e){
	searchEl.value="";
	searchTrigger();
	regexEl.innerHTML=counterEl.innerHTML="";
	container.scrollTop=0;
	e.preventDefault();
},false);

function doStuff(){
	matchArr=container.getElementsByTagName("MATCH");
	var countText=matchArr.length+" coincidencia";
	if(matchArr.length!=1) {
		countText+="s";
		counterEl.innerHTML=countText;
		matchIndex=-1;
	}
	if(matchArr.length){
		counterEl.innerHTML=countText;
		navEl.style.display="inline";
		navPre.disabled=true;
		navNext.disabled=false;
	}
	else{
		navEl.style.display="none";
	}
}

function doNav(offset) {
	matchIndex+=offset;
	matchIndex=matchIndex%matchArr.length;
	matchArr[matchIndex].scrollIntoView(true);
	for(var i=0;i<matchArr.length;i++){
		matchArr[i].style.outline=(matchIndex==i)?"1px solid red":"";
	}
	if(matchArr.length){
		navEl.style.display="inline";
		navPre.disabled=(matchIndex<=0);
		navNext.disabled=(matchIndex>=matchArr.length-1);
	}
	else{
		navEl.style.display="none";
	}
}
