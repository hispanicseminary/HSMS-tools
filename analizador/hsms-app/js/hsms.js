function  quitardias () {
	var lema =document.getElementById("lema");
	var texto = lema.value;
	
	texto = texto.replace(/[ƀḇḅćĉčċçđḍǵĝǧġǥħḥĵǰŀļśŝšşʂṿỳŷźẑžʐɃḆḄĆĈĊČÇĐḌĜǦĠǤĦḤĴĿŚŜŠŞṾỲŶŹŽẐ]/g, function (m) {
    return {
'': '',
'': '',
'ƀ': 'b',
'ḇ': 'b',
'ḅ': 'b',
'ć': 'c',
'ĉ': 'c',
'č': 'c',
'ċ': 'c',
'ç': 'c',
'': 'c',
'đ': 'd',
'ḍ': 'd',
'ǵ': 'g',
'': 'g',
'ĝ': 'g',
'ǧ': 'g',
'ġ': 'g',
'ǥ': 'g',
'ħ': 'h',
'ḥ': 'h',
'': 'j',
'': 'j',
'': 'j',
'ĵ': 'j',
'ǰ': 'j',
'ŀ': 'l',
'ļ': 'l',
'': 'q',
'ś': 's',
'': 's',
'ŝ': 's',
'š': 's',
'ş': 's',
'ʂ': 's',
'': 'v',
'ṿ': 'v',
'': 'x',
'': 'x',
'ỳ': 'y',
'ŷ': 'y',
'ź': 'z',
'': 'z',
'ẑ': 'z',
'ž': 'z',
'': 'z',
'ʐ': 'z',
'Ƀ': 'B',
'Ḇ': 'B',
'Ḅ': 'B',
'Ć': 'C',
'Ĉ': 'C',
'Ċ': 'C',
'Č': 'C',
'Ç': 'C',
'Đ': 'D',
'Ḍ': 'D',
'': 'G',
'Ĝ': 'G',
'Ǧ': 'G',
'Ġ': 'G',
'Ǥ': 'G',
'Ħ': 'H',
'Ḥ': 'H',
'': 'J',
'': 'J',
'Ĵ': 'J',
'': 'J',
'Ŀ': 'L',
'': 'Q',
'': 'R',
'Ś': 'S',
'': 'S',
'Ŝ': 'S',
'Š': 'S',
'Ş': 'S',
'': 'V',
'Ṿ': 'V',
'': 'X',
'Ỳ': 'Y',
'Ŷ': 'Y',
'Ź': 'Z',
'': 'Z',
'Ž': 'Z',
'': 'Z',
'Ẑ': 'Z',
'': 'Z'}[m];
});
	
	lema.value = texto;
    //alert("hola");
}

function ayudapos() {

var caja = $('#pos');

var el = $('#pos').get(0);
var caretPos = el.selectionStart;

//alert($("*:focus").attr("id"));

var statesforms = {
/* 	Inicio: {
		title: 'Ayuda para crear etiquetas EAGLES',
		html:'<label>Nueva <input type="radio" name="logica" value=" " checked> </label>'+
			'<label>Y <input type="radio" name="logica" value="+" > </label>'+
			'<label>O <input type="radio" name="logica" value="/" > </label><br /><br />'+
			'<label>Etiqueta <input type="radio" name="top" value="Etiqueta" checked> </label><br />'+
			'<label>Lema <input type="radio" name="top" value="Lema"> </label><br />'+
			'<label>Forma <input type="radio" name="top" value="Forma"> </label>',
		buttons: { Siguiente: 1, Cerrar: -1 },
		submit:function(e,v,m,f){ 

			if(v==1) $.prompt.goToState($('input:radio[name=top]:checked').val());
			if(v==-1) {
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				$(caja).val($(caja).val().trim());
				$(caja).val($(caja).val().replace(/[\{\}]/g, '' ));

				$.prompt.close();
			}
			e.preventDefault();
		}
	}, //Inicio
 */
	Etiqueta: {
		title: 'Ayuda etiquetas EAGLES: Categoría',
		html:/*'<label> Es: <input type="radio" name="topito" value="{" checked></label>'+
			'<label> No es: <input type="radio" name="topito" value="{!"></label><br /><br />'+*/
			'<label> Sustantivo <input type="radio" name="categoria" value="N" checked> </label><br />'+
			'<label> Adjetivo <input type="radio" name="categoria" value="A"> </label><br />'+
			'<label> Verbo <input type="radio" name="categoria" value="V"> </label><br />'+
			'<label> Adverbio <input type="radio" name="categoria" value="R"> </label><br />'+
			'<label> Determinante <input type="radio" name="categoria" value="D"> </label><br />'+
			'<label> Pronombre <input type="radio" name="categoria" value="P"> </label><br />'+
			'<label> Preposición <input type="radio" name="categoria" value="S"> </label><br />'+
			'<label> Conjunción <input type="radio" name="categoria" value="C"> </label><br />'+
			'<label> Numeral <input type="radio" name="categoria" value="Z"> </label><br />'+
			'<label> Interjección <input type="radio" name="categoria" value="I"> </label><br />'+
			'<label> Puntuación <input type="radio" name="categoria" value="F"> </label>',
		buttons: { Siguiente: 1 },
		//focus: ":input:first",
		submit:function(e,v,m,f){ 
			//console.log(f);

			if(v==1) $.prompt.goToState($('input:radio[name=categoria]:checked').val());
			//if(v==-1) $.prompt.goToState('Inicio');
			e.preventDefault();
		}
	}, //Etiqueta
/*	Lema: {
		title: 'Lema',
		html:'<label> Es: <input type="radio" name="topitolema" value="[" checked></label>'+
			'<label> No es: <input type="radio" name="topitolema" value="[!"></label><br /><br />'+
			'<label> Exactamente <input type="radio" name="tlema" value="1" checked> </label><br />'+
			'<label> Comienza por <input type="radio" name="tlema" value="2"> </label><br />'+
			'<label> Termina en <input type="radio" name="tlema" value="3"> </label><br />'+
			'<label> Contiene <input type="radio" name="tlema" value="4"> </label><br /><br />'+

			'<label>Lema <input type="text" name="Clema" value="" style="width: 150px;"></label>'+

			'<label><select id="Slema" name="Slema">'+
				'<option value=""></option>'+
				'<option value="*">Cualquiera</option>'+
			'</select> </label>',

		buttons: { Finalizar: 1, 'Insertar y seguir': 0, Atrás: -1 },
		submit:function(e,v,m,f){ 
			
			e.preventDefault();
			if(v==1) {

				var lema;

				if ($('input:radio[name=tlema]:checked').val() == '1') {
					lema = $('input:radio[name=topitolema]:checked').val() + $('input:text[name=Clema]').val() + "]";
				}
				else if ($('input:radio[name=tlema]:checked').val() == '2') {
					lema = $('input:radio[name=topitolema]:checked').val()  + $('input:text[name=Clema]').val() + "*]";
				}
				else if ($('input:radio[name=tlema]:checked').val() == '3') {
					lema = $('input:radio[name=topitolema]:checked').val() + "*" + $('input:text[name=Clema]').val() + "]";
				}
				else if ($('input:radio[name=tlema]:checked').val() == '4') {
					lema = $('input:radio[name=topitolema]:checked').val() + "*" + $('input:text[name=Clema]').val() + "*]";
				}

				$(caja).val($(caja).val().substring(0, caretPos) + $('input:radio[name=logica]:checked').val()  + lema.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				$(caja).val($(caja).val().trim());
				$(caja).val($(caja).val().replace(/[\{\}]/g, '' ));

				$.prompt.close();
			}
			if(v==0) { 

				var lema;

				if ($('input:radio[name=tlema]:checked').val() == '1') {
					lema = $('input:radio[name=topitolema]:checked').val() + $('input:text[name=Clema]').val() + "]";
				}
				else if ($('input:radio[name=tlema]:checked').val() == '2') {
					lema = $('input:radio[name=topitolema]:checked').val()  + $('input:text[name=Clema]').val() + "*]";
				}
				else if ($('input:radio[name=tlema]:checked').val() == '3') {
					lema = $('input:radio[name=topitolema]:checked').val() + "*" + $('input:text[name=Clema]').val() + "]";
				}
				else if ($('input:radio[name=tlema]:checked').val() == '4') {
					lema = $('input:radio[name=topitolema]:checked').val() + "*" + $('input:text[name=Clema]').val() + "*]";
				}

				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val()  + lema.toUpperCase() + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) + $('input:radio[name=logica]:checked').val()  + lema.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				var x = $(caja).val().substring(0, caretPos) + $('input:radio[name=logica]:checked').val()  + lema.toUpperCase();
				caretPos = x.length;

				$.prompt.goToState('Inicio');
			}
			if(v==-1) $.prompt.goToState('Inicio');
		}
	}, //Lema
	Forma: {
		title: 'Forma',
		html:'<label> Exactamente <input type="radio" name="tforma" value="1" checked> </label><br />'+
			'<label> Comienza por <input type="radio" name="tforma" value="2"> </label><br />'+
			'<label> Termina en <input type="radio" name="tforma" value="3"> </label><br />'+
			'<label> Contiene <input type="radio" name="tforma" value="4"> </label><br /><br />'+

			'<label>Forma <input type="text" name="Cforma" value="" style="width: 140px;"></label>'+

			'<label><select id="Sforma" name="Sforma">'+
				'<option value=""></option>'+
				'<option value="*">1 forma cualquiera</option>'+
				'<option value="DIST/1">Distancia de 0 a 1 forma</option>'+
				'<option value="DIST/2">Distancia de 0 a 2 formas</option>'+
				'<option value="DIST/3">Distancia de 0 a 3 formas</option>'+
				'<option value="DIST/4">Distancia de 0 a 4 formas</option>'+
				'<option value="DIST/5">Distancia de 0 a 5 formas</option>'+
				'<option value="DIST/6">Distancia de 0 a 6 formas</option>'+
				'<option value="DIST/7">Distancia de 0 a 7 formas</option>'+
				'<option value="DIST/8">Distancia de 0 a 8 formas</option>'+
				'<option value="DIST/9">Distancia de 0 a 9 formas</option>'+
			'</select> </label>',

		buttons: { Finalizar: 1, 'Insertar y seguir': 0, Atrás: -1 },
		submit:function(e,v,m,f){ 
			
			e.preventDefault();
			if(v==1) {

				var forma;

				if ($('input:radio[name=tforma]:checked').val() == '1') {
					forma = $('input:text[name=Cforma]').val() + "";
				}
				else if ($('input:radio[name=tforma]:checked').val() == '2') {
					forma = $('input:text[name=Cforma]').val() + "*";
				}
				else if ($('input:radio[name=tforma]:checked').val() == '3') {
					forma = "*" + $('input:text[name=Cforma]').val() + "";
				}
				else if ($('input:radio[name=tforma]:checked').val() == '4') {
					forma = "*" + $('input:text[name=Cforma]').val() + "*";
				}

				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val()  + forma + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) + $('input:radio[name=logica]:checked').val()  + forma + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				$(caja).val($(caja).val().trim());
				$(caja).val($(caja).val().replace(/[\{\}]/g, '' ));
				
				$.prompt.close();
			}
			if(v==0) { 

				var forma;

				if ($('input:radio[name=tforma]:checked').val() == '1') {
					forma = $('input:text[name=Cforma]').val() + "";
				}
				else if ($('input:radio[name=tforma]:checked').val() == '2') {
					forma = $('input:text[name=Cforma]').val() + "*";
				}
				else if ($('input:radio[name=tforma]:checked').val() == '3') {
					forma = "*" + $('input:text[name=Cforma]').val() + "";
				}
				else if ($('input:radio[name=tforma]:checked').val() == '4') {
					forma = "*" + $('input:text[name=Cforma]').val() + "*";
				}

				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val()  + forma + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) + $('input:radio[name=logica]:checked').val()  + forma + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				var x = $(caja).val().substring(0, caretPos) + $('input:radio[name=logica]:checked').val()  + forma;
				caretPos = x.length;
				$.prompt.goToState('Inicio');
			}
			if(v==-1) $.prompt.goToState('Inicio');
		}
	}, //Forma
*/
	N: {
		title: 'Sustantivo',
		html:'<label><B>Tipo:</B> </label> '+
			'<label> Propio <input type="radio" name="stipo" value="P" checked> </label>'+
			'<label> Común <input type="radio" name="stipo" value="C"> </label><br />'+
			'<label><B>Género:</B> </label> '+
			'<label> Masculino <input type="radio" name="sgenero" value="M"> </label>'+
			'<label> Femenino <input type="radio" name="sgenero" value="F"> </label>'+
			'<label> Común <input type="radio" name="sgenero" value="C"> </label>'+
			'<label>N/A <input type="radio" name="sgenero" value="0" checked> </label><br />'+
			'<label><B>Número:</B></label>'+
			'<label> Singular <input type="radio" name="snumero" value="S"> </label>'+
			'<label> Plural <input type="radio" name="snumero" value="P"> </label>'+
			'<label> Invariable <input type="radio" name="snumero" value="N"> </label>'+
			'<label>N/A <input type="radio" name="snumero" value="0" checked> </label><br />'+
			'<label><B>Semántica:</B> Persona <input type="radio" name="ssemantica" value="SP" checked> </label> '+
			'<label>Lugar <input type="radio" name="ssemantica" value="G0" checked> </label> '+
			'<label>Organización <input type="radio" name="ssemantica" value="O0" checked> </label> '+
			'<label>N/A <input type="radio" name="ssemantica" value="00" checked> </label><br />'+
			'<label><B>Grado:</B> Aumentantivo <input type="radio" name="sgrado" value="A" checked> </label>'+
			'<label>Diminutivo <input type="radio" name="sgrado" value="D" checked> </label>'+
			'<label>N/A <input type="radio" name="sgrado" value="0" checked> </label><br />',

		buttons: { Finalizar: 1, /*'Insertar y seguir': 0,*/ Atrás: -1 },
		submit:function(e,v,m,f){ 
			
			e.preventDefault();
			if(v==1) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=stipo]:checked').val() + $('input:radio[name=sgenero]:checked').val() + $('input:radio[name=snumero]:checked').val() + $('input:radio[name=ssemantica]:checked').val() + $('input:radio[name=sgrado]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val(etiqueta.toUpperCase());
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				$(caja).val($(caja).val().trim());
				$(caja).val($(caja).val().replace(/[\{\}]/g, '' ));
				
				$.prompt.close();
			}
			if(v==0) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=stipo]:checked').val() + $('input:radio[name=sgenero]:checked').val() + $('input:radio[name=snumero]:checked').val() + $('input:radio[name=ssemantica]:checked').val() + $('input:radio[name=sgrado]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				var x = $(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase();
				caretPos = x.length;
				$.prompt.goToState('Inicio');
			}
			if(v==-1) $.prompt.goToState('Etiqueta');
		}

	}, //N
	
	V: {
		title: 'Verbo',
		html:'<label><B>Tipo:</B> </label> '+
			'<label> Principal <input type="radio" name="Vtipo" value="M" checked> </label>'+
			'<label> Auxiliar <input type="radio" name="Vtipo" value="A"> </label>'+
			'<label> Semiauxiliar <input type="radio" name="Vtipo" value="S"> </label><br />'+

			'<label><B>Modo:</B> <select name="Vmodo">'+
				'<option value="I">Indicativo</option>'+
				'<option value="S">Subjuntivo</option>'+
				'<option value="M">Imperativo</option>'+
				'<option value="N" selected>Infinitivo</option>'+
				'<option value="G">Gerundio</option>'+
				'<option value="P">Participio</option>'+
			'</select> </label><br />'+

			'<label><B>Tiempo:</B> <select name="Vtiempo">'+
				'<option value="P">Presente</option>'+
				'<option value="I">Imperfecto</option>'+
				'<option value="F">Futuro</option>'+
				'<option value="S">Pasado</option>'+
				'<option value="C">Condicional</option>'+
				'<option value="0" selected>N/A</option>'+
			'</select> </label><br />'+

			'<label><B>Persona:</B> </label>'+
			'<label> Primera <input type="radio" name="Vpersona" value="1" > </label>'+
			'<label> Segunda <input type="radio" name="Vpersona" value="2" > </label>'+
			'<label> Tercera <input type="radio" name="Vpersona" value="3" > </label>'+
			'<label> N/A <input type="radio" name="Vpersona" value="0" checked> </label><br />'+
			'<label><B>Número:</B> </label>'+
			'<label> Singular <input type="radio" name="Vnumero" value="S"> </label>'+
			'<label> Plural <input type="radio" name="Vnumero" value="P"> </label>'+
			'<label> N/A <input type="radio" name="Vnumero" value="0" checked> </label><br />'+
			'<label><B>Género:</B> </label>'+
			'<label> Masculino <input type="radio" name="Vgenero" value="M"> </label>'+
			'<label> Femenino <input type="radio" name="Vgenero" value="F"> </label>'+
			'<label> N/A <input type="radio" name="Vgenero" value="0" checked> </label>',
		buttons: { Finalizar: 1, /*'Insertar y seguir': 0,*/ Atrás: -1 },
		submit:function(e,v,m,f){ 

			e.preventDefault();
			if(v==1) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=Vtipo]:checked').val() + $('select[name="Vmodo"] option:selected').val() + 		$('select[name="Vtiempo"] option:selected').val()  + $('input:radio[name=Vpersona]:checked').val() + $('input:radio[name=Vnumero]:checked').val() + $('input:radio[name=Vgenero]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val(etiqueta.toUpperCase());
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				$(caja).val($(caja).val().trim());
				$(caja).val($(caja).val().replace(/[\{\}]/g, '' ));

				$.prompt.close();
			}
			if(v==0) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=Vtipo]:checked').val() + $('select[name="Vmodo"] option:selected').val() + 		$('select[name="Vtiempo"] option:selected').val()  + $('input:radio[name=Vpersona]:checked').val() + $('input:radio[name=Vnumero]:checked').val() + $('input:radio[name=Vgenero]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				var x = $(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase();
				caretPos = x.length;

				$.prompt.goToState('Inicio');
			}
			if(v==-1) $.prompt.goToState('Etiqueta');
		}

	}, //V	

	A: {
		title: 'Adjetivo',
		html:'<label><B>Tipo:</B> </label> '+
			'<label> Calificativo <input type="radio" name="Atipo" value="Q" checked> </label>'+
			'<label> Ordinal <input type="radio" name="Atipo" value="O"> </label><br />'+
			'<label><B>Grado:</B> Aumentativo <input type="radio" name="Agrado" value="A" > </label>'+
			'<label> Diminutivo <input type="radio" name="Agrado" value="D" > </label>'+
			'<label> Comparativo <input type="radio" name="Agrado" value="C" > </label>'+
			'<label> Superlativo <input type="radio" name="Agrado" value="S" > </label>'+
			'<label> N/A <input type="radio" name="Agrado" value="0" checked> </label><br />'+
			'<label><B>Género:</B> </label>'+
			'<label> Masculino <input type="radio" name="Agenero" value="M" checked> </label>'+
			'<label> Femenino <input type="radio" name="Agenero" value="F"> </label>'+
			'<label> Común <input type="radio" name="Agenero" value="C"> </label><br />'+
			'<label><B>Número:</B> </label>'+
			'<label> Singular <input type="radio" name="Anumero" value="S" checked> </label>'+
			'<label> Plural <input type="radio" name="Anumero" value="P"> </label>'+
			'<label> Invariable <input type="radio" name="Anumero" value="N"> </label><br />'+
			'<label><B>Función:</B> </label>'+
			'<label> - <input type="radio" name="Afuncion" value="0" checked> </label>'+
			'<label> Participio <input type="radio" name="Afuncion" value="P"> </label>',
		buttons: { Finalizar: 1, /*'Insertar y seguir': 0,*/ Atrás: -1 },
		submit:function(e,v,m,f){ 
			
			e.preventDefault();
			if(v==1) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=Atipo]:checked').val() + $('input:radio[name=Agrado]:checked').val() + $('input:radio[name=Agenero]:checked').val() + $('input:radio[name=Anumero]:checked').val() + $('input:radio[name=Afuncion]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val(etiqueta.toUpperCase());
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				$(caja).val($(caja).val().trim());
				$(caja).val($(caja).val().replace(/[\{\}]/g, '' ));

				$.prompt.close();
			}
			if(v==0) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=Atipo]:checked').val() + $('input:radio[name=Agrado]:checked').val() + $('input:radio[name=Agenero]:checked').val() + $('input:radio[name=Anumero]:checked').val() + $('input:radio[name=Afuncion]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				var x = $(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase();
				caretPos = x.length;

				$.prompt.goToState('Inicio');
			}
			if(v==-1) $.prompt.goToState('Etiqueta');
		}

	}, //A	

	R: {
		title: 'Adverbio',
		html:'<label><B>Tipo:</B></label><br />'+
			'<label> General <input type="radio" name="Rtipo" value="G" checked> </label><br />'+
			'<label> Negativo <input type="radio" name="Rtipo" value="N"> </label><br />'+
			'<label> Modo <input type="radio" name="Rtipo" value="M"> </label><br />'+
			'<label> Espacio <input type="radio" name="Rtipo" value="E"> </label><br />'+
			'<label> Tiempo <input type="radio" name="Rtipo" value="T"> </label><br />'+
			'<label> Espacio-tiempo <input type="radio" name="Rtipo" value="X"> </label><br />'+
			'<label> Aspecto <input type="radio" name="Rtipo" value="A"> </label><br />'+
			'<label> Cantidad <input type="radio" name="Rtipo" value="C"> </label><br />'+
			'<label> Indefinido <input type="radio" name="Rtipo" value="I"> </label><br />'+
			'<label> Deíctico <input type="radio" name="Rtipo" value="D"> </label>',
		buttons: { Finalizar: 1, /*'Insertar y seguir': 0,*/ Atrás: -1 },
		submit:function(e,v,m,f){ 
			
			e.preventDefault();
			if(v==1) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=Rtipo]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val(etiqueta.toUpperCase());
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				$(caja).val($(caja).val().trim());
				$(caja).val($(caja).val().replace(/[\{\}]/g, '' ));

				$.prompt.close();
			}
			if(v==0) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=Rtipo]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				var x = $(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase();
				caretPos = x.length;

				$.prompt.goToState('Inicio');
			}
			if(v==-1) $.prompt.goToState('Etiqueta');
		}

	}, //R

	D: {
		title: 'Determinante',
		html:'<label><B>Tipo:</B> <select name="Dtipo">'+
				'<option value="A" selected>Artículo</option>'+
				'<option value="D">Demostrativo</option>'+
				'<option value="P">Posesivo</option>'+
				'<option value="T">Interrogativo</option>'+
				'<option value="E">Exclamativo</option>'+
				'<option value="I">Indefinido</option>'+
			'</select> </label><br />'+
			'<label><B>Persona:</B> N/A <input type="radio" name="Dpersona" value="0" checked> </label>'+
			'<label> Primera <input type="radio" name="Dpersona" value="1"> </label>'+
			'<label> Segunda <input type="radio" name="Dpersona" value="2" > </label>'+
			'<label> Tercera <input type="radio" name="Dpersona" value="3" > </label><br />'+
			'<label><B>Género:</B> </label>'+
			'<label> Mascul. <input type="radio" name="Dgenero" value="M" checked> </label>'+
			'<label> Femen. <input type="radio" name="Dgenero" value="F"> </label>'+
			'<label> Común <input type="radio" name="Dgenero" value="C"> </label>'+
			'<label> Neutro <input type="radio" name="Dgenero" value="N"> </label><br />'+
			'<label><B>Número:</B> </label>'+
			'<label> Singular <input type="radio" name="Dnumero" value="S" checked> </label>'+
			'<label> Plural <input type="radio" name="Dnumero" value="P"> </label>'+
			'<label> Invariable <input type="radio" name="Dnumero" value="N"> </label><br />'+
			'<label><B>Poseedor:</B> N/A <input type="radio" name="Dposeedor" value="0" checked> </label>'+
			'<label> Singular <input type="radio" name="Dposeedor" value="S"> </label>'+
			'<label> Plural <input type="radio" name="Dposeedor" value="P"> </label>',

		buttons: { Finalizar: 1, /*'Insertar y seguir': 0,*/ Atrás: -1 },
		submit:function(e,v,m,f){ 
			
			e.preventDefault();
			if(v==1) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() +  $('select[name="Dtipo"] option:selected').val() +  $('input:radio[name=Dpersona]:checked').val() + $('input:radio[name=Dgenero]:checked').val() + $('input:radio[name=Dnumero]:checked').val() + $('input:radio[name=Dposeedor]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val(etiqueta.toUpperCase());
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				$(caja).val($(caja).val().trim());
				$(caja).val($(caja).val().replace(/[\{\}]/g, '' ));

				$.prompt.close();
			}
			if(v==0) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() +  $('select[name="Dtipo"] option:selected').val() +  $('input:radio[name=Dpersona]:checked').val() + $('input:radio[name=Dgenero]:checked').val() + $('input:radio[name=Dnumero]:checked').val() + $('input:radio[name=Dposeedor]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				var x = $(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase();
				caretPos = x.length;

				$.prompt.goToState('Inicio');
			}
			if(v==-1) $.prompt.goToState('Etiqueta');
		}

	}, //D

	P: {
		title: 'Pronombre',
		html:'<label><B>Tipo:</B> <select name="Ptipo">'+
				'<option value="P" selected>Personal</option>'+
				'<option value="D">Demostrativo</option>'+
				'<option value="X">Posesivo</option>'+
				'<option value="T">Interrogativo</option>'+
				'<option value="E">Exclamativo</option>'+
				'<option value="I">Indefinido</option>'+
				'<option value="R">Relativo</option>'+
			'</select> </label><br />'+
			'<label><B>Persona:</B> N/A <input type="radio" name="Ppersona" value="0" checked> </label>'+
			'<label> Primera <input type="radio" name="Ppersona" value="1" > </label>'+
			'<label> Segunda <input type="radio" name="Ppersona" value="2" > </label>'+
			'<label> Tercera <input type="radio" name="Ppersona" value="3" > </label><br />'+
			'<label><B>Género:</B> </label>'+
			'<label> Mascul. <input type="radio" name="Pgenero" value="M" checked> </label>'+
			'<label> Femen. <input type="radio" name="Pgenero" value="F"> </label>'+
			'<label> Común <input type="radio" name="Pgenero" value="C"> </label>'+
			'<label> Neutro <input type="radio" name="Pgenero" value="N"> </label><br />'+
			'<label><B>Número:</B> </label>'+
			'<label> Singular <input type="radio" name="Pnumero" value="S" checked> </label>'+
			'<label> Plural <input type="radio" name="Pnumero" value="P"> </label>'+
			'<label> Imper./Invar. <input type="radio" name="Pnumero" value="N"> </label><br />'+
			'<label><B>Caso:</B> N/A <input type="radio" name="Pcaso" value="0" checked> </label>'+
			'<label> Nominat. <input type="radio" name="Pcaso" value="N"> </label>'+
			'<label> Acusativ. <input type="radio" name="Pcaso" value="A"> </label>'+
			'<label> Dativ. <input type="radio" name="Pcaso" value="D"> </label>'+
			'<label> Oblicuo <input type="radio" name="Pcaso" value="O"> </label><br />'+
			'<label><B>Poseedor:</B> N/A <input type="radio" name="Pposeedor" value="0" checked> </label>'+
			'<label> Singular <input type="radio" name="Pposeedor" value="S"> </label>'+
			'<label> Plural <input type="radio" name="Pposeedor" value="P"> </label><br />'+
			'<label><B>Cortesía:</B> N/A <input type="radio" name="Ppoliteness" value="0" checked> </label>'+
			'<label> Cortés <input type="radio" name="Ppoliteness" value="P"> </label>',

		buttons: { Finalizar: 1, /*'Insertar y seguir': 0,*/ Atrás: -1 },
		submit:function(e,v,m,f){ 
			
			e.preventDefault();
			if(v==1) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() +  $('select[name="Ptipo"] option:selected').val() +  $('input:radio[name=Ppersona]:checked').val() + $('input:radio[name=Pgenero]:checked').val() + $('input:radio[name=Pnumero]:checked').val() + $('input:radio[name=Pcaso]:checked').val() + $('input:radio[name=Pposeedor]:checked').val() + $('input:radio[name=Ppoliteness]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val(etiqueta.toUpperCase());
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				$(caja).val($(caja).val().trim());
				$(caja).val($(caja).val().replace(/[\{\}]/g, '' ));

				$.prompt.close();
			}
			if(v==0) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() +  $('select[name="Ptipo"] option:selected').val() +  $('input:radio[name=Ppersona]:checked').val() + $('input:radio[name=Pgenero]:checked').val() + $('input:radio[name=Pnumero]:checked').val() + $('input:radio[name=Pcaso]:checked').val() + $('input:radio[name=Pposeedor]:checked').val() + $('input:radio[name=Ppoliteness]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				var x = $(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase();
				caretPos = x.length;

				$.prompt.goToState('Inicio');
			}
			if(v==-1) $.prompt.goToState('Etiqueta');
		}

	}, //P

	S: {
		title: 'Preposición',
		html:'<label><B>Tipo:</B></label><br />'+
			'<label> Simple <input type="radio" name="SStipo" value="PS00" checked> </label><br />'+
			'<label> Contracción <input type="radio" name="SStipo" value="PC00"> </label>',
		buttons: { Finalizar: 1, /*'Insertar y seguir': 0,*/ Atrás: -1 },
		submit:function(e,v,m,f){ 
			
			e.preventDefault();
			if(v==1) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=SStipo]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val(etiqueta.toUpperCase());
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				$(caja).val($(caja).val().trim());
				$(caja).val($(caja).val().replace(/[\{\}]/g, '' ));

				$.prompt.close();
			}
			if(v==0) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=SStipo]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				var x = $(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase();
				caretPos = x.length;

				$.prompt.goToState('Inicio');
			}
			if(v==-1) $.prompt.goToState('Etiqueta');
		}

	}, //S

	C: {
		title: 'Conjunción',
		html:'<label><B>Tipo:</B> </label><br />'+
			'<label> Coordinada <input type="radio" name="Ctipo" value="C" checked> </label><br />'+
			'<label> Subordinada <input type="radio" name="Ctipo" value="S"> </label>',
		buttons: { Finalizar: 1, /*'Insertar y seguir': 0,*/ Atrás: -1 },
		submit:function(e,v,m,f){ 
			
			e.preventDefault();
			if(v==1) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=Ctipo]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val(etiqueta.toUpperCase());
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				$(caja).val($(caja).val().trim());
				$(caja).val($(caja).val().replace(/[\{\}]/g, '' ));

				$.prompt.close();
			}
			if(v==0) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=Ctipo]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				var x = $(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase();
				caretPos = x.length;

				$.prompt.goToState('Inicio');
			}
			if(v==-1) $.prompt.goToState('Etiqueta');
		}

	}, //C

	Z: {
		title: 'Numeral',
		html:'<label><B>Tipo:</B><br /> N/A <input type="radio" name="Ztipo" value="" checked> </label><br />'+
			'<label> Partitivo <input type="radio" name="Ztipo" value="d"> </label><br />'+
			'<label> Moneda <input type="radio" name="Ztipo" value="m"> </label><br />'+
			'<label> Porcentaje <input type="radio" name="Ztipo" value="p"> </label>'+
			'<label> Unidad <input type="radio" name="Ztipo" value="u"> </label>',
		buttons: { Finalizar: 1, /*'Insertar y seguir': 0,*/ Atrás: -1 },
		submit:function(e,v,m,f){ 
			
			e.preventDefault();
			if(v==1) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=Ztipo]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val(etiqueta.toUpperCase());
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				$(caja).val($(caja).val().trim());
				$(caja).val($(caja).val().replace(/[\{\}]/g, '' ));

				$.prompt.close();
			}
			if(v==0) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=Ztipo]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				var x = $(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase();
				caretPos = x.length;

				$.prompt.goToState('Inicio');
			}
			if(v==-1) $.prompt.goToState('Etiqueta');
		}

	}, //Z

	I: {
		title: 'Interjección',
		html:'<label><B>Tipo:</B><br /> Cualquiera <input type="radio" name="Itipo" value="" checked> </label><br />',
		buttons: { Finalizar: 1, /*'Insertar y seguir': 0,*/ Atrás: -1 },
		submit:function(e,v,m,f){ 
			
			e.preventDefault();
			if(v==1) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=Itipo]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val(etiqueta.toUpperCase());
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				$(caja).val($(caja).val().trim());
				$(caja).val($(caja).val().replace(/[\{\}]/g, '' ));

				$.prompt.close();
			}
			if(v==0) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('input:radio[name=Itipo]:checked').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val(etiqueta.toUpperCase());
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				var x = $(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase();
				caretPos = x.length;

				$.prompt.goToState('Inicio');
			}
			if(v==-1) $.prompt.goToState('Etiqueta');
		}

	}, //I

	F: {
		title: 'Puntuación',
		html:'<label><B>Tipo:</B> <select name="Putipo">'+
		'<option value="Faa">¡</option>'+
		'<option value="Fat">!</option>'+
		'<option value="Fc">,</option>'+
		'<option value="Fca">[</option>'+
		'<option value="Fct">]</option>'+
		'<option value="Fd">:</option>'+
		'<option value="Fe">"</option>'+
		'<option value="Fg">-</option>'+
		'<option value="Fh">/</option>'+
		'<option value="Fia">¿</option>'+
		'<option value="Fit">?</option>'+
		'<option value="Fla">{</option>'+
		'<option value="Flt">}</option>'+
		'<option value="Fp" selected>.</option>'+
		'<option value="Fpa">(</option>'+
		'<option value="Fpt">)</option>'+
		'<option value="Fra">«</option>'+
		'<option value="Frc">»</option>'+
		'<option value="Fs">...</option>'+
		'<option value="Ft">%</option>'+
		'<option value="Fx">;</option>'+
		'<option value="Fz">_</option>'+
		'<option value="Fz">+</option>'+
		'<option value="Fz">=</option>'+
		'</select> </label>',
		buttons: { Finalizar: 1, /*'Insertar y seguir': 0,*/ Atrás: -1 },
		submit:function(e,v,m,f){ 
			
			e.preventDefault();
			if(v==1) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ /*$('input:radio[name=categoria]:checked').val() +*/ $('select[name="Putipo"] option:selected').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val(etiqueta.toUpperCase());
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				$(caja).val($(caja).val().trim());
				$(caja).val($(caja).val().replace(/[\{\}]/g, '' ));

				$.prompt.close();
			}
			if(v==0) {
				var etiqueta = /*$('input:radio[name=topito]:checked').val() +*/ $('input:radio[name=categoria]:checked').val() + $('select[name="Ptipo"] option:selected').val() + "}";
				//$(caja).val($(caja).val() + $('input:radio[name=logica]:checked').val() + etiqueta + ' ');
				$(caja).val($(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase() + ' ' + $(caja).val().substring(caretPos) );
				$(caja).val($(caja).val().replace(/ +/g, ' ' ));
				$(caja).val($(caja).val().replace(/\s\//g, '/' ));
				$(caja).val($(caja).val().replace(/\s\+/g, '+' ));
				$(caja).val($(caja).val().replace(/^\//, '' ));
				$(caja).val($(caja).val().replace(/^\+/, '' ));
				var x = $(caja).val().substring(0, caretPos) /*+ $('input:radio[name=logica]:checked').val()*/  + etiqueta.toUpperCase();
				caretPos = x.length;

				$.prompt.goToState('Inicio');
			}
			if(v==-1) $.prompt.goToState('Etiqueta');
		}

	}, //F

};

$.prompt(statesforms, {
	loaded: function(){

			///////////////////////////////////////////////////////////////////////////////$("#Slema").load("lemas.php");

//			$.ajax({url: "lemas.php",
//				success: function(output) {
//					$('#Slema').html(output);
//				}
//			});

			//$('#Slema').on('change', function() {
			//	$('input:text[name=Clema]').val($('select[name="Slema"] option:selected').val());  
			//});

			//$('#Sforma').on('change', function() {
			//	$('input:text[name=Cforma]').val($('select[name="Sforma"] option:selected').val());  
			//});

			//$('input:radio[name=tforma]').on('click', function() {
			//	if ($('input:radio[name=tforma]:checked').val() != '1') {$('select[name="Sforma"]').prop('disabled', true); $('select[name="Sforma"]').hide();}
			//	else if ($('input:radio[name=tforma]:checked').val() == '1') {$('select[name="Sforma"]').prop('disabled', false);$('select[name="Sforma"]').show();}
			//});

	},
	statechanged:function(e, s){
		if (s == 'Inicio') {
			$('input:radio[name=logica][value=" "]').prop("checked", true);
		}
	},
	top: '30%'

});

}
