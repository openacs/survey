<master src="master">

<property name="survey_id">@survey_id@</property>

<property name="survey_id">@survey_id@</property>
<property name="survey_name@">@survey_info.name@</property>
<property name="title">One Respondent: @first_names@ @last_name@</property>
<property name="context_bar">@context_bar@</property>
<table class=table-display cellspacing=0 cellpadding=5>
<tr class="table-header"><td>
  Here is what <a href="/shared/community-member?user_id=@user_id@">@first_names@ @last_name@</a> had to say in response to @survey_name@:
</td>


<multiple name="responses">

    <tr class="odd"><td>
<group column="initial_response">

<if @responses.original_p@><a href="response-delete?response_id=@response_id@">
<img valign="top" align="right" src="/graphics/delete.gif" border="0" alt="Delete"></a>
</if>
 <strong>[<if
      @responses.original_p@>Original</if><else>Edited</a></else>
      Response on @responses.creation_date@]</strong> 
	  <br />
@responses.response_display@


</group>
</td>
</tr>
<tr class="odd"><td><hr class="main_color"></td></tr>
</multiple>
</table>

