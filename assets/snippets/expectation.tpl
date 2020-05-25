//<?php
/**
 * expectation
 *
 * Ожидание товара
 *
 * @category	snippet
 * @internal	@modx_category expectation
 * @internal	@installset base
 * @internal	@overwrite true
 * @internal	@properties 
 */

if ((!isset($count))	|| ($count>0)) return;

if (!function_exists('GetIP'))	
{
	function GetIP() {
	  if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
		$ip = $_SERVER['HTTP_CLIENT_IP'];
	  } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
		$ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
	  } else {
		$ip = $_SERVER['REMOTE_ADDR'];
	  }
	  return $ip;
	}
}
if (!function_exists('compress_html_for_js'))
{
	function compress_html_for_js($compress)
	{
		$compress = str_replace("\n", '', $compress);
		$compress = str_replace("\s", '', $compress);
		$compress = str_replace("\r", '', $compress);
		$compress = str_replace("\t", '', $compress);
		$compress = preg_replace('/(?:(?<=\>)|(?<=\/\>))\s+(?=\<\/?)/', '', $compress);
		$compress = preg_replace('/[\t\r]\s+/', ' ', $compress);
		$compress = preg_replace('/<!(--)([^\[|\|])^(<!-->.*<!--.*-->)/', '', $compress);
		$compress = preg_replace('/\/\*.*?\*\//', '', $compress);
		$compress = preg_replace("#\\s+#ism"," ",$compress);
		return addslashes($compress);
	}
}
include_once(MODX_BASE_PATH.'assets/snippets/DocLister/lib/DLTemplate.class.php');
$tpl = DLTemplate::getInstance($modx);

$ip = GetIP();
$id = $modx->documentIdentifier;

$yet = isset($yet) ? $yet : '@CODE: <p>Вы уже подписались на ожидание</p>';
$result = isset($result) ? $result : $yet;
$form = isset($form) ? $form : '@CODE: <form method="post"><input name="expectation_email" placeholder="Введите Ваш email"><input type="submit"></form>';
$form = $tpl->parseChunk($form);
$yet = $tpl->parseChunk($yet);
$result = $tpl->parseChunk($result);



if (($ajaxMode==1) && ($idForm))
{	
	$form = '<div id="expectation_div_'.$idForm.'">'.$form.'</div>';
	$yet = '<div id="expectation_div_'.$idForm.'">'.$yet.'</div>';
	$result = '<div id="expectation_div_'.$idForm.'">'.$result.'</div>';
	
	$form = str_replace('<form','<form id="expectation_form_'.$idForm.'"',$form);
	echo '<script>
	document.addEventListener(\'DOMContentLoaded\', function(){
	document.getElementById("expectation_form_'.$idForm.'").addEventListener("submit", function(evt){
		evt.preventDefault();		
		const request_'.$idForm.' = new XMLHttpRequest(); 		
		const params_'.$idForm.' = "expectation_email="+document.getElementById("expectation_form_'.$idForm.'").getElementsByTagName("input")[0].value;		
		request_'.$idForm.'.open("POST", "'.$modx->makeUrl($id).'");
		request_'.$idForm.'.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		request_'.$idForm.'.addEventListener("readystatechange", () => {
			{
				if (request_'.$idForm.'.readyState === 4 && request_'.$idForm.'.status === 200) {						
					document.getElementById("expectation_div_'.$idForm.'").innerHTML = "'.compress_html_for_js($result).'";						
				}
			}});
			request_'.$idForm.'.send(params_'.$idForm.');			
		});
	});
	</script>';	
	
}

if ($modx->db->getValue('Select count(*) from '.$modx->getFullTableName('expectation').' where pid='.$id.' and ip="'.$ip.'"')) return $yet;

if (isset($_POST['expectation_email']))
{		
	$modx->db->insert(array('pid'=>$id,'email'=>$modx->db->escape($_POST['expectation_email']),'date'=>time(),'ip'=>$ip),$modx->getFullTableName('expectation'));
	return $result;	
}
else return $form;
