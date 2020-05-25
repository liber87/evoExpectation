//<?php
/**
 * NotificationOfProductAppearance
 *
 * NotificationOfProductAppearance
 *
 * @category    plugin
 * @internal    @events OnDocFormSave,OnDocFormDelete
 * @internal    @modx_category expectation
 * @internal    @properties &tvid=ID TВ-параметра с количеством;number;13 &subject=Тема письма;text;Запрашиваемый вами товар появился на сайте &content=Чанк с письмом;text;@CODE: <p>Сообщаем вам, что запрашиваемый вами товар <b>[+pagetitle+]</b> <a href='[+url+]'>Появился на сайте</a> </p>;или через @CODE:
 * @internal    @disabled 0
 * @internal    @installset base
 */
if (($modx->event->name=='OnDocFormSave') && ($tvid) && ($mode=='upd'))
{
	$modx->loadExtension('MODxMailer');	
	include_once(MODX_BASE_PATH.'assets/snippets/DocLister/lib/DLTemplate.class.php');
	$tpl = DLTemplate::getInstance($modx);
	$sd = $modx->db->query('Select * from '.$modx->getFullTableName('site_content').' where id='.$id);
	$doc = $modx->db->getRow($sd);

	$tvs = array();		
	
	$res = $modx->db->query('SELECT name,value FROM '.$modx->getFullTableName('site_tmplvar_contentvalues').'
	as vals left join '.$modx->getFullTableName('site_tmplvars').' as tv 
	on tv.id = vals.tmplvarid where vals.contentid='.$id);
	while ($row = $modx->db->getRow($res)) $tvs[$row['name']] = $row['value'];
	$docs = array_merge($doc,$tvs);		
	$docs['url'] = $modx->makeUrl($id,'','','full');
	
	$content = $tpl->parseChunk($content,$docs);
		
	$res = $modx->db->query('select e.id,email from '.$modx->getFulltableName('expectation').' as e
							left join '.$modx->getFulltableName('site_tmplvar_contentvalues').' as tv
							on tv.contentid = e.pid and tv.tmplvarid='.$tvid.' and tv.value>0
							where e.pid='.$id);
	
	while($row = $modx->db->getRow($res))
	{		
		$mail = $modx->mail;	
		$mail->IsHTML(true);
		$mail->From = $modx->config['emailsender'];
		$mail->FromName = $modx->config['site_name'];
		$mail->Subject = $subject; 			
		$mail->Body = $content;
		$mail->addAddress($row['email']); 
		$mail->send(); 
		$modx->db->query('Delete from '.$modx->getFulltableName('expectation').' where id='.$row['id']);
	}
}
if ($modx->event->name=='OnDocFormDelete') $modx->db->query('delete from '.$modx->getFulltableName('expectation').' where pid='.$id);
