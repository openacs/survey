<master src="master">

<property name="survey_id">@survey_id@</property>

<property name="survey_id">@survey_id@</property>
<property name="survey_name@">@survey_info.name@</property>
<property name="title">#survey.lt_One_Respondent_first_#</property>
<property name="context_bar">@context_bar@</property>
<table class=table-display cellspacing=0 cellpadding=5>
<tr class="table-header"><td>
  #survey.Here_is_what# <a href="/shared/community-member?user_id=@user_id@">@first_names@ @last_name@</a> #survey.lt_had_to_say_in_respons#
</td>


<multiple name="responses">

    <tr class="odd"><td>
<group column="initial_response">

<if @responses.original_p@><a href="response-delete?response_id=@response_id@">
<img valign="top" align="right" src="../graphics/delete.gif" border="0" alt="#survey.Delete#"></a>
</if>
 <strong>[<if
      @responses.original_p@>#survey.Original#</if><else>#survey.Edited#</a></else>
      #survey.lt_Response_on_responses#</strong> 
	  <br />
@responses.response_display@


</group>
</td>
</tr>
<tr class="odd"><td><hr class="main_color"></td></tr>
</multiple>
</table>



